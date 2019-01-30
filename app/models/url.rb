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

  def find_errors
    return self.errors.messages
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


