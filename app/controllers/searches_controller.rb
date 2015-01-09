class SearchesController < OrganizationAwareController

  ASSET_SEARCH_TYPE             = '1'
  CAPITAL_PLAN_SEARCH_TYPE      = '2'
  ORGANIZATION_SEARCH_TYPE      = '3'
  USER_SEARCH_TYPE              = '4'
  FUNDING_SOURCE_SEARCH_TYPE    = '5'
  FUNDING_LINE_ITEM_SEARCH_TYPE = '6'

  # Set the view variables form the params @search_type, @searcher_klass
  before_filter :set_view_vars,     :only => [:create, :new]
                  
  def create

    @searcher = @searcher_klass.constantize.new(params[:searcher])
    @searcher.user = current_user
    @data = @searcher.data

    add_breadcrumb "Search"
    add_breadcrumb "Results"
            
    # Cache the result set so the use can page through them
    unless @searcher.cache_variable_name.blank?
      cache_list(@data, @searcher.cache_variable_name)
    end
              
    respond_to do |format|
      format.html { render 'new' }
      format.js   { render 'new' }
      format.json { render :json => @data }
    end
    
  end

  # Render the inventory search form
  def new

    @searcher = @searcher_klass.constantize.new
    @searcher.user = current_user
    @data = []

    add_breadcrumb "Search"
          
    respond_to do |format|
      format.html # new.html.erb
    end    
  end

  def full_text_search

    #testing w "981ECCHHGG58 981ECCD92F8E"

    search_text = params["search_text"]

    search_results = []

    search_criteria = "1=2"
    search_params = {}
    search_text.split(" ").each {|search_string|
      if search_string.length > 3
        search_criteria += " OR search_text like '%#{search_string}%'"
      end
    }

    results = FullTextSearchIndex.where(search_criteria)

    binding.pry

    @full_text_search_results = results

    x = 1

  end
  
  protected
  
  def set_view_vars

    add_breadcrumb "Home", root_path

    @search_type = params[:search_type]
    if @search_type == ASSET_SEARCH_TYPE
      @searcher_klass = "AssetSearcher"
      add_breadcrumb "Assets", inventory_index_path
    elsif @search_type == CAPITAL_PLAN_SEARCH_TYPE
      @searcher_klass = "CapitalProjectSearcher"
      add_breadcrumb "Capital Projects", capital_projects_path
    elsif @search_type == ORGANIZATION_SEARCH_TYPE
      @searcher_klass = "OrganizationSearcher"
      add_breadcrumb "Organizations", organizations_path
    elsif @search_type == USER_SEARCH_TYPE
      @searcher_klass = "UserSearcher"
      add_breadcrumb "Users", users_path
    elsif @search_type == FUNDING_SOURCE_SEARCH_TYPE
      @searcher_klass = "FundingSourceSearcher"
      add_breadcrumb "Funds", funding_sources_path
    elsif @search_type == FUNDING_LINE_ITEM_SEARCH_TYPE
      @searcher_klass = "FundingLineItemSearcher"
      add_breadcrumb "Appropriations", funding_line_items_path
    else
      notify_user(:alert, "Something went wrong. Can't determine type of search to perform.")
      redirect_to root_path
      return     
    end
    
  end

end
