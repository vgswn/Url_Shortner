RDoc::Task.new do |rdoc|
  rdoc.rdoc_dir = 'doc/app'
  rdoc.generator = 'sdoc'
  rdoc.template = 'rails'
  rdoc.main = 'README.md'
  rdoc.rdoc_files.include('README.md', 'app/', 'lib/')
end
=begin
	
	swagger: '2.0'
info:
  description: This is Url Shortner API for converting Long Url into Short and vice-versa.
  version: 1.0.0
  title: Url Shortner
  contact:
    email: vipul.kumar@proptiger.com
host: '10.10.2.70:3000'
basePath: /
tags:
  - name: Url Shortner
    description: Convert Urls
paths:
  /shorten-url:
    post:
      tags:
        - Url Shortner
      summary: Convert and save Long Url and domain into short Url
      consumes:
        - application/json
      produces:
        - json
      parameters:
        - in: body
          name: long_url
          description: Long url that needs to be shorten
          required: true
          type: string
          enum:
            - 'https://www.google.com'
            - 'https://www.cricbuzz.com'
          example: www.cricbuzz.com
        - name: domain
          in: body
          description: Domain of Long Url
          required: true
          type: string
          enum:
            - google.com
            - cricbuzz.com
          example: cricbuzz.com
      responses:
        '200':
          description: OK
    get:
      tags:
        - Url Shortner
      summary: Get Long Url and domain using Short Url
      consumes:
        - application/json
      produces:
        - json
      parameters:
        - in: body
          name: short_url
          description: Short Url that finds the long url
          required: true
          type: string
          enum:
            - www.goco/8ffdefb
            - 8ffdefb
          example: 8ffdefb
      responses:
        '200':
          description: OK

	
=end