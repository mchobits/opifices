#please run `ruby config/stiemap.rb`

require 'rubygems'
require 'sitemap_generator'
CFG = YAML.load_file("#{Rails.root}/config/project.yml")[Rails.env]
SitemapGenerator::Sitemap.default_host = CFG['siteurl']

SitemapGenerator::Sitemap.create do

  Category.find_each do |category|
    add category_path(category.id),changefreq: 'daily'
  end
  Blog.find_each do |blog|
    add blog_path(blog.slug_url), lastmod: blog.updated_at,priority: 0.6
  end
end

SitemapGenerator::Sitemap.ping_search_engines(baidu: 'http://ping.baidu.com/sitemap')