class BackendDataMoorisController < ApplicationController
  def backend_data_mooris
  	require 'BxClient'
    require 'BxData'

    @account = "mooris_stage" # your account name
	@password = "gjuibprz5rdt292g" # your account password
	@domain = "" # your web-site domain (e.g.: www.abc.com)
	@languages = Array.new(['de']) #declare the list of available languages
	@isDev = false #are the data to be pushed dev or prod data?
	@isDelta = false #are the data to be pushed full data (reset index) or delta (add/modify index)?
	@logs = Array.new #optional, just used here in example to collect logs
	@print = true

	#Create the Boxalino Data SDK instance
	bxData = BxData.new(BxClient.new(@account, @password, @domain, @isDev, @host, request), @languages, @isDev, @isDelta)

	begin

	    #Product export
	    @file = 'C:/Users/Next-Olive/Desktop/Mooris_Data/mooris/executions.csv' #a csv file with header row
	    @itemIdColumn = 'id' #the column header row name of the csv with the unique id of each item
			@mainColumns = Array.new(["execution_id","execution_description","execution_archive","execution_name_intern","execution_notes","execution_name_vendor","execution_ek_price","execution_ek_currency","execution_vk_price","execution_art_number_vendor","execution_notes_vendor","execution_vk_price_eur","execution_notes_logistics","execution_created_at","execution_updated_at","execution_image_file_name","execution_image_content_type","execution_image_file_size","execution_image_updated_at","execution_article_id","execution_ean","execution_group_name","execution_number_on_stock","execution_last_inventar","execution_zolltarifnummer","execution_product_template_id","execution_product_option_1","execution_product_option_2","execution_product_option_3","execution_list_price","execution_list_price_currency","execution_gallery_pic_id","articles_id","articles_description","articles_cover_image_gallery_pic_id_id","articles_company_id","articles_archive","articles_age_restriction","articles_name_intern","articles_notes","articles_name_vendor","articles_created_at","articles_updated_at","articles_ek_price","articles_ek_currency","articles_vk_price","articles_art_number_vendor","articles_notes_vendor","articles_vk_price_euro","articles_image_file_name","articles_image_content_type","articles_image_file_size","articles_image_updated_at","articles_origin_country","articles_notes_logistics","articles_bring_in_costs","articles_additional_costs","articles_possible_discount","articles_links","articles_product_template_id","articles_unit_size","articles_ean","articles_label_id","articles_theme_id","articles_zolltarifnummer","articles_visible","articles_buyable","articles_price_visible","articles_product_search_id","articles_art_number_vendor_type","articles_logistics_company_id","articles_intern_logistics_notes","articles_to_google","articles_delivery_story","articles_list_price","articles_list_price_currency","articles_google_category_id","articles_buyer_id","articles_category","articles_google_category","articles_active_options","articles_vat_included","articles_vat_rate","articles_price_list_link","articles_list_price_updated_at","articles_list_price_updated_by","articles_main_category","articles_expected_delivery_costs","articles_sub_theme_id","articles_sub_label_id","articles_offerte_draft","articles_delivery_condition_id","articles_bought","articles_turnover","articles_views","articles_returns"])

	    #add a csv file as main product file
	    @sourceKey = bxData.addMainCSVItemFile(@file, @itemIdColumn)

	    #declare the fields
	    bxData.addSourceTitleField(@sourceKey, Hash.new({"de"=>"articles_name_intern"}))
	    bxData.addSourceDescriptionField(@sourceKey, Hash.new({"de"=>"articles_name_vendor"}))
	    bxData.addSourceListPriceField(@sourceKey, "articles_ek_price")
	    bxData.addSourceDiscountedPriceField(@sourceKey, "articles_ek_price")
			mainColumns.each do |mainColumn|
				bxData.addSourceStringField(@sourceKey, mainColumn, mainColumn)
			end
		
	    executionToProductFile = 'C:/Users/Next-Olive/Desktop/Mooris_Data/mooris/executions_articles_products_keys.csv'
	    executionToProductSourceKey = bxData.addCSVItemFile(executionToProductFile, 'id')
		@productIdColumn = 'product_id'
		
	    @subFile = 'C:/Users/Next-Olive/Desktop/Mooris_Data/mooris/gallery_pics.csv' #a csv file with header row
		@subFileColumn = 'gallery_pics_id'
	    subFileSourceKey = bxData.addResourceFile(@subFile, @productIdColumn, Hash.new({'de'=>@subFileColumn}))
	    bxData.addSourceLocalizedTextField(executionToProductSourceKey, @subFileColumn, @productIdColumn, subFileSourceKey)
		
	    @subFile = 'C:/Users/Next-Olive/Desktop/Mooris_Data/mooris/product_options.csv' #a csv file with header row
		@subFileColumn = 'product_options_label'
	    subFileSourceKey = bxData.addResourceFile(@subFile, @productIdColumn, Hash.new({'de'=>@subFileColumn}))
	    bxData.addSourceLocalizedTextField(executionToProductSourceKey, @subFileColumn, @productIdColumn, subFileSourceKey)
		
	    @subFile = 'C:/Users/Next-Olive/Desktop/Mooris_Data/mooris/products.csv' #a csv file with header row
		@subFileColumn = 'products_category'
	    subFileSourceKey = bxData.addResourceFile(@subFile, @productIdColumn, Hash.new({'de'=>@subFileColumn}))
	    bxData.addSourceLocalizedTextField(executionToProductSourceKey, @subFileColumn, @productIdColumn, subFileSourceKey)
		
	    @subFile = 'C:/Users/Next-Olive/Desktop/Mooris_Data/mooris/additionals.csv' #a csv file with header row
		@subFileColumn = 'additional_informations_label'
	    subFileSourceKey = bxData.addResourceFile(@subFile, @productIdColumn, Hash.new({'de'=>@subFileColumn}))
	    bxData.addSourceLocalizedTextField(executionToProductSourceKey, @subFileColumn, @productIdColumn, subFileSourceKey)
		
	    @subFile = 'C:/Users/Next-Olive/Desktop/Mooris_Data/mooris/themes.csv' #a csv file with header row
		@subFileColumn = 'themes_name'
	    subFileSourceKey = bxData.addResourceFile(@subFile, 'themes_id', Hash.new({'de'=>@subFileColumn}))
	    bxData.addSourceLocalizedTextField(@sourceKey, @subFileColumn, 'articles_theme_id', subFileSourceKey)
		
	    @subFile = 'C:/Users/Next-Olive/Desktop/Mooris_Data/mooris/labels.csv' #a csv file with header row
		@subFileColumn = 'labels_name'
	    subFileSourceKey = bxData.addResourceFile(@subFile, 'labels_id', Hash.new({'de'=>@subFileColumn}))
	    bxData.addSourceLocalizedTextField(@sourceKey, @subFileColumn, 'articles_label_id', subFileSourceKey)
		
	   #Transaction export
	    @transactionFile = 'C:/Users/Next-Olive/Desktop/Mooris_Data/mooris/transactions.csv' #a csv file with header row, this file should contain one entry per product and per transaction (so the same transaction should appear several time if it contains more than 1 product
	    @orderIdColumn = 'order_items_id' #the column header row name of the csv with the order (or transaction) id
	    @transactionProductIdColumn = 'execution_id' #the column header row name of the csv with the product id
	    @transactionCustomerIdColumn = 'order_items_user_id' #the column header row name of the csv with the customer id
	    @orderDateIdColumn = 'order_items_created_at' #the column header row name of the csv with the order date
	    @totalOrderValueColumn = 'order_amount' #the column header row name of the csv with the total order value
	    @productListPriceColumn = 'order_items_unit_price' #the column header row name of the csv with the product list price
	    @productDiscountedPriceColumn = 'order_items_unit_price' #the column header row name of the csv with the product price after discounts (real price paid)

	    #optional fields, provided here with default values (so, no effect if not provided), matches the field to connect to the transaction product id and customer id columns (if the ids are not the same as the itemIdColumn of your products and customers files, then you can define another field)
	    @transactionProductIdField = 'bx_item_id' #default value (can be left null) to define a specific field to map with the product id column
	    @transactionCustomerIdField = 'bx_customer_id' #default value (can be left null) to define a specific field to map with the product id column

	    #add a csv file as main customer file
	    bxData.setCSVTransactionFile(@transactionFile, @orderIdColumn, @transactionProductIdColumn, @transactionCustomerIdColumn, @orderDateIdColumn, @totalOrderValueColumn, @productListPriceColumn, @productDiscountedPriceColumn, @transactionProductIdField, @transactionCustomerIdField)

	    @logs.push("publish the data specifications")
	    bxData.pushDataSpecifications()

	    @logs.push("publish the api owner changes") #if the specifications have changed since the last time they were pushed
	    bxData.publishChanges()

	    @logs.push("push the data for data sync")
	    bxData.pushData()
	    if(@print)
	        @message = @logs.join("<br/>")
	    end
		

	rescue Exception => e

      #be careful not to print the error message on your publish web-site as sensitive information like credentials might be indicated for debug purposes
      @message =  e
      @exception = e
    end
	# @message = @message  + "finished"
  end
end
