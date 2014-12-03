class BlogController < ApplicationController
  def index
    tumblr = File.expand_path(File.dirname(__FILE__) + '../../../config/tumblr.yml')

    if File.exists? tumblr
      config = YAML.load_file(tumblr)
      config.each { |key, value| ENV[key] || ENV[key] = value.to_s }
    end

    blog = ENV['TUMBLR_BLOG']
    @recent_posts = tumblr_client.posts(blog, limit: 30)['posts']
    @text = []
    @videos = []
    @photos = []
    @recent_posts.each do |p|
      case p['type']
        when 'text'
          @text << p
        when 'photo'
          @text << p
        when 'video'
          @text << p
      end
    end
    @articles = {}
    @text.each do |post|
      date = post['date'].to_datetime
      id = post['id']
      title = post['title']
      key = date.strftime("%B %Y")
      if @articles.has_key? key
        @articles[key] << { id: id, title: title, date: date }
      else
        @articles[key] = [{ id: id, title: title, date: date }]
      end
    end
    post_id = params['post']
    @post = post_id.blank? ? @text.first : @text.find {|p| p['id'] == post_id.to_i }
    @articles.each { |a, v| v.sort_by! { |hsh| hsh[:date] }.reverse!}
    @articles = Hash[@articles.sort_by { |k, v| k.to_datetime }]
  end

  def new
  end

  def edit_post
    tumblr_client.edit(ENV['TUMBLR_BLOG'], id: params['blog_id'], title: params['title'], body: params['edit_body'])
    redirect_to blog_index_path
  end

  def new_post
    tumblr_client.text(ENV['TUMBLR_BLOG'], title: params['title'], body: params['post_body'])
    redirect_to blog_index_path
  end

  def delete_post
    result = tumblr_client.delete(ENV['TUMBLR_BLOG'], params['post_id'])
    if result['id'] == params['post_id'].to_i
      BlogComment.where(post_id: params['post_id'].to_i).destroy_all
    end
    redirect_to blog_index_path
  end

  def comments
    @comments = BlogComment.where(post_id: params['post_id']).by_date
    render partial: '/blog/comments', locals: { comments: @comments }
  end

  def new_comment
    comment = params['comment']
    name = comment['name'].blank? ? 'Anonymous' : comment['name']
    id = comment['id']
    text = comment['comment']
    c = BlogComment.new
    c.name = name
    c.comment = text
    c.post_id = id
    c.status = 'pending'
    c.save
    comments = BlogComment.where(post_id: id).by_date
    render partial: '/blog/comments', locals: { comments: comments }
  end

  def approve_comment
    b = BlogComment.find(params['id'])
    b.status = 'approved'
    b.save
    render nothing: true
  end

  def delete_comment
    b = BlogComment.find(params['id'])
    b.destroy
    redirect_to blog_index_path
  end

  private

  def tumblr_client
    if @tumblr.blank?
      Tumblr.configure do |config|
        config.client = :HTTPClient
        config.consumer_key = ENV['TUMBLR_OAUTH_KEY']
        config.consumer_secret = ENV['TUMBLR_OAUTH_SECRET']
        config.oauth_token = ENV['TUMBLR_API_TOKEN']
        config.oauth_token_secret = ENV['TUMBLR_API_TOKEN_SECRET']
      end
      @tumblr = Tumblr::Client.new
    end
    @tumblr
  end
end
