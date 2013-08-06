class TagsController < ApplicationController
  def show
    @tag = Tag.find_by_name(params[:id])
    @posts = Post.tagged_with(params[:id])
    post_ids = @posts.pluck(:id)


    #@start_date = @posts.first.created_at.utc.to_i * 1000
    # @t = LazyHighCharts::HighChart.new('graph') do |f|
    #   f.options[:chart][:defaultSeriesType] = "line"
    #   f.options[:title][:text] = "Tag Engagement"
    #   f.options[:subtitle][:text] = "Number of Checkins on Top 10 Actions"
    #   f.options[:plotOptions][:area] = { stacking: "normal", pointStart: @start_date, pointInterval: 1.day * 1000 }
    #   f.options[:xAxis][:type] ='datetime'
    #   f.options[:yAxis][:title] = 'Takers'
    #   @posts.each do |p|
    #     f.series(:name=>"#{p.short_title}", :data => p.checkins_per_day )
    #   end
    # end

    # @t = LazyHighCharts::HighChart.new('graph') do |f|
    #   f.options[:chart][:defaultSeriesType] = "area"
    #   f.series(:name=>'John', :data=>[3, 20, 3, 5, 4, 10, 12 ,3, 5,6,7,7,80,9,9])
    #   f.series(:name=>'Jane', :data=> [1, 3, 4, 3, 3, 5, 4,-46,7,8,8,9,9,0,0,9] )
    # end    
  end
end

# xAxis: {
#                 categories: ['1750', '1800', '1850', '1900', '1950', '1999', '2050'],
#                 tickmarkPlacement: 'on',
#                 title: {
#                     enabled: false
#                 }
#             },
#             yAxis: {
#                 title: {
#                     text: 'Billions'
#                 },
#                 labels: {
#                     formatter: function() {
#                         return this.value / 1000;
#                     }
#                 }
#             },