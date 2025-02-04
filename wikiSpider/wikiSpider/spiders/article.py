from scrapy.linkextractors import LinkExtractor
from scrapy.spiders import CrawlSpider, Rule
from wikiSpider.items import Article


class ArticleSpider(CrawlSpider):
    name = 'articles'
    allowed_domains = ['wikipedia.org']
    start_urls = ['https://en.wikipedia.org/wiki/Benevolent_dictator_for_life']
    rules = [
        Rule(LinkExtractor(allow='^(https://en.wikipedia.org/wiki/)((?!:).)*$'), callback='parse_items',
             follow=True)
    ]

    def parse_items(self, response):
        article = Article()
        article['url'] = response.url
        article['title'] = response.css('h1::text').get()
        article['text'] = response.xpath(
            '//div[@id="mw-content-text"]//text()').getall()
        lastUpdated = response.css(
            'li#footer-info-lastmod::text').get()
        article['lastUpdated'] = lastUpdated.replace(
            'This page was last edited on ', '')

        return article
