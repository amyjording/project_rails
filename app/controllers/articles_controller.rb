class ArticlesController < ApplicationController
  before_filter :month
  before_filter :top3
  before_filter :require_login, except: [:index, :show]

  include ArticlesHelper
  def index
    @articles = Article.all

  end
  def show
    @article = Article.find(params[:id])
    @comment = Comment.new
    @comment.article_id = @article.id
    @article.increment
  end
  def new
    @article = Article.new
  end
  def create
    @article = Article.new(article_params)
    @article.author = current_user
    @article.save
    flash.notice = "Article '#{@article.title}' Created!"
    redirect_to article_path(@article)
  end

  def destroy
    @article = Article.destroy(params[:id])
    flash.notice = "Article '#{@article.title}' Deleted."
    redirect_to (articles_path)
  end
  def edit
    @article = Article.find(params[:id])
    if session[:current_user_id] != @article.author
      flash.notice = "Sorry, you can't edit this article."
      redirect_to(articles_path)
    end
  end
 def update
   @article = Article.find(params[:id])
   @article.update(article_params)
   flash.notice = "Article '#{@article.title}' Updated!"
   redirect_to article_path(@article)
 end
 def feed
  @articles = Article.all
  respond_to do |format|
    format.rss { render :layout => false }
  end
end

  def top3
     @top_3_articles = Article.order('views DESC').first(3)
   end

   def month
    @article_months = Article.all.group_by { |r| r.created_at.beginning_of_month }
   end

  private

    def article_params
      params.require(:article).permit(:title, :body, :image, :author_id)
    end
end
