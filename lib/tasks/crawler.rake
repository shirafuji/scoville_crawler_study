namespace :crawler do
  desc 'Run the crawler'
  task run: :environment do
    puts "started crawling..."

    url = "https://tech.sc0ville.com/"
    Anemone.crawl(url, depth_limit: 0) do |anemone|
      anemone.on_every_page do |page|
        doc = Nokogiri::HTML.parse(page.body)
        article_divs = doc.xpath(%Q[/html/body/main/section/div[1]/div[@class="articleFeatured"]])
        article_divs.each do |article|
          title = article.xpath(%Q[div[@class="title"]/h2]).text
          date = article.xpath(%Q[div[@class="title"]/div[@class="info"]/p[2]]).text
          p title
          p date
        end
      end
    end
    
    puts "done"
  end
end
