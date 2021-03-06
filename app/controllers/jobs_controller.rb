class JobsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :update, :edit, :destroy]
  before_action :validate_search_key, only: [:search]

  def index
    

    # 目前只能单个条件筛选 #
    # 判断是否筛选城市 #
    if params[:location].present?
      @location = params[:location]
      if @location == '所有城市'
        @jobs = Job.published.recent.paginate(:page => params[:page], :per_page => 10)
      else
        @jobs = Job.where(:is_hidden => false, :location => @location).recent.paginate(:page => params[:page], :per_page => 10)
      end

    # 判断是否筛选职位类型 #
    elsif params[:category].present?
      @category = params[:category]
      if @category == '所有类型'
        @jobs = Job.published.recent.paginate(:page => params[:page], :per_page => 10)
      else
        @jobs = Job.where(:is_hidden => false, :category => @category).recent.paginate(:page => params[:page], :per_page => 10)
      end

    # 判断是否筛选薪水 #
    elsif params[:wage].present?
      @wage = params[:wage]
      if @wage == '5k以下'
        @jobs = Job.wage1.recent.paginate(:page => params[:page], :per_page => 10)
      elsif @wage == '5~10k'
        @jobs = Job.wage2.recent.paginate(:page => params[:page], :per_page => 10)
      elsif @wage == '10~15k'
        @jobs = Job.wage3.recent.paginate(:page => params[:page], :per_page => 10)
      elsif @wage == '15~25k'
        @jobs = Job.wage4.recent.paginate(:page => params[:page], :per_page => 10)
      else
        @jobs = Job.wage5.recent.paginate(:page => params[:page], :per_page => 10)
      end

    # 预设显示所有公开职位 #
    else
      @jobs = Job.published.recent.paginate(:page => params[:page], :per_page => 10)
    end
  end

=begin
    @jobs = case params[:order]
            when 'by_lower_bound'
              Job.published.order('wage_lower_bound DESC')
            when 'by_upper_bound'
              Job.published.order('wage_upper_bound DESC')
            else
              Job.published.recent
            end
  end
=end

  def show
    @job = Job.find(params[:id])




    if @job.is_hidden
      flash[:warning] = "This Job already archieved"
      redirect_to root_path
    end
  end

  def new
    @job = Job.new
  end

  def create
    @job = Job.new(job_params)

    if @job.save
      redirect_to jobs_path
    else
      render :new
    end
  end

  def edit
    @job = Job.find(params[:id])
  end

  def update
    @job = Job.find(params[:id])
    if @job.update(job_params)
      redirect_to jobs_path
    else
      render :edit
    end
  end

  def destroy
    @job = Job.find(params[:id])

    @job.destroy

    redirect_to jobs_path
  end

  def search
  if @query_string.present?
    search_result = Job.published.ransack(@search_criteria).result(:distinct => true)
    @jobs = search_result.recent.paginate(:page => params[:page], :per_page => 5 )
  end
end


  private

  def job_params
    params.require(:job).permit(:title, :description, :wage_upper_bound, :wage_lower_bound, :contact_email, :is_hidden, :category, :company, :city)
  end

  protected
    def validate_search_key
      @query_string = params[:q].gsub(/\\|\'|\/|\?/, "")
      if params[:q].present?
        @search_criteria =  {
          title_or_company_or_city_cont: @query_string
        }
      end
    end

    def search_criteria(query_string)
      { :title_cont => query_string }
    end


end
