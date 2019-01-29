class Url < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  validates :long_url,uniqueness: true
  validates :domain , presence: true
  validates_format_of :long_url , :with =>	URI::regexp(%w(http https))
  after_create :put_in_report_table_async 

  settings index: {
  number_of_shards: 1,
  number_of_replicas: 0,
  analysis: {
     analyzer: {
        pattern: {
           type: 'pattern',
           pattern: "\\s|_|-|\\.",
           lowercase: true
        },
        trigram: {
          tokenizer: 'trigram'
        }
      },
     tokenizer: {
        trigram: {
           type: 'ngram',
           min_gram: 3,
           max_gram: 1000,
           token_chars: ['letter', 'digit']
        }
     }
    } 
  } do
    mapping do
      indexes :short_url, type: 'text', analyzer: 'english' do
        indexes :keyword, analyzer: 'keyword'
        indexes :pattern, analyzer: 'pattern'
        indexes :trigram, analyzer: 'trigram'
      end
      indexes :long_url, type: 'text', analyzer: 'english' do
        indexes :keyword, analyzer: 'keyword'
        indexes :pattern, analyzer: 'pattern'
        indexes :trigram, analyzer: 'trigram'
      end
    end
  end

  def as_indexed_json(options={})
    as_json(
      only: [:long_url, :short_url,:domain]
    ) 
  end


  def self.shorten_url(params)
    begin
      entry = Url.create!(params)
      prefix= Rails.cache.fetch(params[:domain], :expires_in => 5.minutes) do 
        DomainPrefixHelper.find_domain_prefix(params[:domain])
      end	        
      short_url=UrlsHelper.md5hash(params[:long_url])
      short_url=UrlsHelper.check_collision_md5(short_url)
      params[:short_url]=short_url
      entry.update_attributes(params)
      return {"Status"=>"Success","short_url"=> prefix+short_url,"long_url"=>params[:long_url],"domain"=>params[:domain]}


    rescue Exception => exception

      if exception.to_s.include? "invalid"
        return {"Status" => "Error","Error"=>"Enter Valid Url"}

      elsif exception.to_s.include? "blank"
        return {"Status" => "Error","Error"=>"Enter All Params"}

      else
        row  =	Rails.cache.fetch(params[:long_url], :expires_in => 5.minutes) do 
          Url.where(long_url: params[:long_url]).first
        end
        prefix= Rails.cache.fetch(params[:domain], :expires_in => 5.minutes) do 
          DomainPrefixHelper.find_domain_prefix(row[:domain])
        end

        if row[:short_url] == nil
          row.destroy
          return {"Status" => "Error","Error"=>"Something Went Wrong"}
        else
          return {"Status"=>"Already Exists","short_url"=>prefix+row[:short_url],"long_url"=>row[:long_url],"domain"=>row[:domain]}
        end
      end
    end
  end

  def self.short_url(params)
    begin
      row=	Rails.cache.fetch(params[:short_url], :expires_in => 5.minutes) do
        Url.where(short_url: params[:short_url]).first
      end
      prefix= Rails.cache.fetch(row[:domain], :expires_in => 5.minutes) do 
        DomainPrefixHelper.find_domain_prefix(row[:domain])
      end
      return {"Status"=>"OK !","long_url"=>row[:long_url],"domain"=>row[:domain],"short_url"=>prefix+params[:short_url]}
    rescue Exception => exception
      return {"Status"=>"Nothing Found !"}
    end	
  end


  def self.custom_search(params)
    field = params[:field]+".trigram"
    query = params[:query] 
    urls = self.__elasticsearch__.search(
    {
     query: {
      bool: {
       must: [{
        term: {
         "#{field}":"#{query}"
        }
       }]
      }
     }
    }).records
    return urls
  end

  def put_in_report_table_async
    UrlWorker.perform_async({url_id: self.id})
  end
end

