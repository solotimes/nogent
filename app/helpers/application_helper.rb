module ApplicationHelper
	def body_tag(cls=nil,&block)
	  body_class << cls
	  return @cls if @cls
	  @cls = []
	  @cls << "#{params[:controller]}_controller"
	  @cls << [params[:action],params[:controller]]*'_'
	  @cls << I18n.locale.to_s
	  @cls << Rails.env
	  @cls << @body_class
	  @cls = @cls.flatten.compact.map(&:parameterize)*' '
	  content_tag :body, :class => @cls ,&block
	end

	def body_class
	  @body_class ||=[]
	end

	def current_class(item,options={})
	  current_item = options[:current_item] || @page
	  class_string = options[:class] || 'current'
	  method = (!options[:exact]) ? :is_or_is_ancestor_of? : :==
	  if current_item.present? && item.send(method,current_item)
	      class_string
	  else
	      nil
	  end
	end

	def item_class(index,total,item,options={})
		res = []
	  res << 'first' if index.zero?
	  res << 'last' if total == index + 1
	  res << current_class(item,options)
	  res.join(' ')
	end

	def default_for(name,&block)
	  if content_for?(name)
	    content_for(name)
	  else
	    capture(&block)
	  end
	end

	##
	# 生成页面的标题Tag, text为页面的标题, suffix页面标题后缀

	def title_tag(text=nil, suffix=I18n.t('site_title',:default => 'Site Title'))
	  title = [text,suffix].compact.join('-')
	  content_tag(:title, title)
	end
end
