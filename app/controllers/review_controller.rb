class ReviewController < ApplicationController
  def index
    @reviews = Review.all.order('created_at DESC')
    @main_videos = Video.all.order('priority')
    @first_main = @main_videos.first
  end

  def add_review
    r = Review.new
    r.name = params['name']
    r.comment = params['review']
    r.approved = false
    r.save
    redirect_to home_path
  end

  def text_review
    r = Review.new
    r.name = params['name']
    r.comment = params['review']
    r.approved = false
    r.save
    redirect_to reviews_path
  end

  def approve_text_review
    review = Review.find(params['id'])
    review.approved = true
    review.save
    redirect_to reviews_path
  end

  def remove_text_review
    Review.find(params['id']).destroy
    redirect_to reviews_path
  end

  def add_video
    vid = Video.new
    last_vid = Video.all.order('priority').last
    last_id = last_vid.nil? ? 0 : last_vid.priority
    vid.priority = last_id + 1
    vid.url = params['url']
    vid.save if params['url']
    redirect_to reviews_path
  end

  def video_review
  end

  def delete_video
    key = params['key']
    video = Video.find(:all, conditions: ['url LIKE ?', "%#{key}%"])
    video.first.destroy if video
    render nothing: true
  end
end
