class BlogController < ApplicationController
  def index
    @articles = {}
    @recent_posts = tumblr_client.posts(ENV['TUMBLR_BLOG'], limit: 30)['posts']
    @recent_posts.each do |external_post|
      post = Post.where(id: external_post['id']).first_or_initialize
      date = external_post['date'].to_datetime
      post.update_attributes!(title: external_post['title'], body: external_post['body'], post_date: date)
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
    @post = post_id.blank? ? Post.order('post_date').last : Post.find(post_id)
    @articles.each { |a, v| v.sort_by! { |hsh| hsh[:date] }}
    @articles = Hash[@articles.sort_by { |k, v| k.to_datetime }.reverse! ]
     feed = Feedjira::Feed.fetch_and_parse("http://davematthews.tumblr.com/rss")
    @entries = []
    feed.entries.each do |e|
      @entries << {title: e.title, content: e.summary.html_safe}
    end
  end

  def new
    @post = Post.new
  end

  def edit
    @post = Post.find(params['post'])
  end

  def edit_post
    blog_id = params['id']
    post = params['post']
    title = post['title']
    body = post['body']
    Post.find(blog_id).update_attributes!(title: title, body: body)
    tumblr_client.edit(ENV['TUMBLR_BLOG'], id: blog_id, title: title, body: body)
    redirect_to blog_index_path
  end

  def new_post
    post = params['post']
    title = post['title']
    body = post['body']
    post = tumblr_client.text(ENV['TUMBLR_BLOG'], title: title, body: body)
    Post.create!(id: post['id'], title: title, body: body)
    redirect_to blog_index_path
  end

  def delete_post
    post_id = params['post_id']
    result = tumblr_client.delete(ENV['TUMBLR_BLOG'], post_id)
    Post.find(post_id).destroy!
    redirect_to blog_index_path
  end

  def comments
    @comments = Post.find(params['post_id']).blog_comments.by_date
    render partial: '/blog/comments', locals: { comments: @comments }
  end

  def new_comment
    comment = params['comment']
    name = comment['name'].blank? ? 'Anonymous' : comment['name']
    id = comment['id']
    text = comment['comment']
    post = Post.find(comment['post_id'])
    comment = BlogComment.new
    comment.name = name
    comment.comment = text
    comment.status = 'pending'
    post.blog_comments << comment
    render partial: '/blog/comments', locals: { comments: post.blog_comments.by_date }
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
