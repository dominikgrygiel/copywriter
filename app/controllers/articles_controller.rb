class ArticlesController < ApplicationController
  before_filter :no_subdomains, :except => [:index]
  before_filter :login_required, :except => [:index, :show]
  before_filter :find_article, :only => [:edit, :update, :destroy]

  # GET /articles
  # GET /articles.json
  def index
    if request.subdomain.present?
      @category = Category.find_by_subdomain!(request.subdomain)
      @articles = @category.articles
    else
      @articles = Article
    end
    @articles = @articles.page(params[:page]).per(5)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @articles }
    end
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
    @article = Article.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @article }
    end
  end

  # GET /articles/new
  # GET /articles/new.json
  def new
    @article = current_user.articles.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @article }
    end
  end

  # GET /articles/1/edit
  def edit
  end

  # POST /articles
  # POST /articles.json
  def create
    @article = current_user.articles.new(params[:article])

    respond_to do |format|
      if @article.save
        format.html { redirect_to article_url(current_user, @article), notice: 'Article was successfully created.' }
        format.json { render json: @article, status: :created, location: @article }
      else
        format.html { render action: "new" }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /articles/1
  # PUT /articles/1.json
  def update
    respond_to do |format|
      if @article.update_attributes(params[:article])
        format.html { redirect_to article_url(current_user, @article), notice: 'Article was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    @article.destroy

    respond_to do |format|
      format.html { redirect_to root_url }
      format.json { head :no_content }
    end
  end

private
  def no_subdomains
    redirect_to(URI.parse(root_url(:subdomain => false)).merge(request.path).to_s, :status => :moved_permanently) and return if request.subdomain.present?
  end

  def find_article
    @article = current_user.articles.find(params[:id])
  end

end

