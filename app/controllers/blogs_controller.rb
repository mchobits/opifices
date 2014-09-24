class BlogsController < ApplicationController
  caches_page :show
  def index
    @blogs = Blog.recent.page(params[:page]).per(6)
    params[:page].blank? ? @page_title = '首页' : @page_title = "第#{params[:page]}页"
  end

  def category
    @category = Category.find(params[:id])
    if @category
      @page_title = @category.name
      @blogs = Blog.recent.where(category_id: @category.id).page(params[:page]).per(6)
      render 'blogs/index'
    else
      redirect_to root_path, alert: '您所访问的博文分类不存在'
    end
  end

  def show
    @blog = Blog.find_by(slug_url: params[:slug])
    redirect_to root_path, alert: '您所访问的博文不存在' unless @blog
  end

  def feed
    @blogs = Blog.recent.limit(20)
    render layout: false,content_type: 'application/xml',formats: :xml
  end
end
