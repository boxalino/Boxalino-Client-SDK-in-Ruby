class BackendPagesController < ApplicationController

  def initialize(account = "csharp_unittest" , password= "csharp_unittest", exception1=nil, host="cdn.bx-cloud.com")
    @account = account
    @password = password
    @host = host
    @exception = exception1
    @domain = "" # your web-site domain (e.g.: www.abc.com)
    @logs = Array.new #optional, just used here in example to collect logs
    @isDev = false #are the data to be pushed dev or prod data?
    @isDelta = false #are the data to be pushed full data (reset index) or delta (add/modify index)?
    @languages = ['en']
  end

  def backend_data_basic
    #@message = "Hello, how are you today?"
    require 'json'
    require 'BxData'
    require 'BxClient'
    #required parameters you should set for this example to work
    # @account = "boxalino_automated_tests"; # your account name
    # @password = "boxalino_automated_tests"; # your account password
    # @domain = "" # your web-site domain (e.g.: www.abc.com)
    # @languages = ['en'] #declare the list of available languages
    # @isDev = false #are the data to be pushed dev or prod data?
    # @isDelta = false #are the data to be pushed full data (reset index) or delta (add/modify index)?
    @logs = Array.new #optional, just used here in example to collect logs
    bxData = BxData.new(BxClient.new(@account, @password, @domain) , @languages, @isDev, @isDelta)
    begin

      file = 'sample_data/products.csv' #a csv file with header row
      itemIdColumn = 'id' #the column header row name of the csv with the unique id of each item

      #add a csv file as main product file
      sourceKey = bxData.addMainCSVItemFile(file, itemIdColumn)

      #this part is only necessary to do when you push your data in full, as no specifications changes should not be published without a full data sync following next
      #even when you publish your data in full, you don't need to repush your data specifications if you know they didn't change, however, it is totally fine (and suggested) to push them everytime if you are not sure if something changed or not
      if(!@isDelta)

        #declare the fields
        bxData.addSourceTitleField(sourceKey, {"en"=>"name_en"})
        bxData.addSourceDescriptionField(sourceKey, {"en"=>"description_en"})
        bxData.addSourceListPriceField(sourceKey, "list_price");
        bxData.addSourceDiscountedPriceField(sourceKey, "discounted_price");
        bxData.addSourceLocalizedTextField(sourceKey, "short_description", {"en"=>"short_description_en"})
        bxData.addSourceStringField(sourceKey, "sku", "sku")

        @logs.push("publish the data specifications")
        bxData.pushDataSpecifications();

        @logs.push("publish the api owner changes") #if the specifications have changed since the last time they were pushed
        bxData.publishChanges()
      end

      @logs.push("push the data for data sync")
      bxData.pushData()
      @message = @logs.join("<br/>")

    rescue Exception => e

      #be careful not to print the error message on your publish web-site as sensitive information like credentials might be indicated for debug purposes
      @message =  e
      
    end
  end

  def backend_data_basic_xml
    require 'json'
    require 'BxData'
    require 'BxClient'
    #required parameters you should set for this example to work
    # @account = "boxalino_automated_tests"; # your account name
    # @password = "boxalino_automated_tests"; # your account password
    # @domain = "" # your web-site domain (e.g.: www.abc.com)
    # @languages = ['en'] #declare the list of available languages
    # @isDev = false #are the data to be pushed dev or prod data?
    # @isDelta = false #are the data to be pushed full data (reset index) or delta (add/modify index)?
    # @logs = Array.new #optional, just used here in example to collect logs
    bxData = BxData.new(BxClient.new(@account, @password, @domain) , @languages, @isDev, @isDelta)
    begin

      file = 'sample_data/products.csv' #a csv file with header row
      itemIdColumn = 'id'; #the element of the xml with the unique id of each item
      xPath = '/products/product'; #path from the root to the products
      #add a csv file as main product file
      sourceKey = bxData.addMainXmlItemFile(file, itemIdColumn, xPath)

      #this part is only necessary to do when you push your data in full, as no specifications changes should not be published without a full data sync following next
      #even when you publish your data in full, you don't need to repush your data specifications if you know they didn't change, however, it is totally fine (and suggested) to push them everytime if you are not sure if something changed or not
      if(!@isDelta)

        #declare the fields
        bxData.addSourceTitleField(sourceKey, {"en"=>"name/translation[@locale='en']"})
        bxData.addSourceDescriptionField(sourceKey, {"en"=>"description/translation[@locale='en']"})
        bxData.addSourceListPriceField(sourceKey, "list_price")
        bxData.addSourceDiscountedPriceField(sourceKey, "discounted_price")
        bxData.addSourceLocalizedTextField(sourceKey, "short_description", {"en"=>"short_description/translation[@locale='en']"})
        bxData.addSourceStringField(sourceKey, "sku", "sku")

        @logs.push("publish the data specifications")
        bxData.pushDataSpecifications()

        @logs.push("publish the api owner changes") #if the specifications have changed since the last time they were pushed
        bxData.publishChanges();
      end

      @logs.push("push the data for data sync")
      bxData.pushData()
      @message = @logs.join("<br/>")
      
    rescue Exception => e 

      #be careful not to print the error message on your publish web-site as sensitive information like credentials might be indicated for debug purposes
      @message =  e
      
    end
  end

  def backend_data_categories
    require 'json'
    require 'BxData'
    require 'BxClient'
    #required parameters you should set for this example to work
    # @account = ""; # your account name
    # @password = ""; # your account password
    # @domain = "" # your web-site domain (e.g.: www.abc.com)
    # @languages = ['en'] #declare the list of available languages
    # @isDev = false #are the data to be pushed dev or prod data?
    # @isDelta = false #are the data to be pushed full data (reset index) or delta (add/modify index)?
    # @logs = Array.new #optional, just used here in example to collect logs
    bxData = BxData.new(BxClient.new(@account, @password, @domain) , @languages, @isDev, @isDelta)
    begin

      mainProductFile = 'sample_data/products.csv' #a csv file with header row
      itemIdColumn = 'id'; #the element of the xml with the unique id of each item
      
      categoryFile = 'sample_data/categories.csv' #a csv file with header row
      categoryIdColumn = 'category_id' #column header row name of the csv with the unique category id
      parentCategoryIdColumn = 'parent_id' #column header row name of the csv with the parent category id
      categoryLabelColumns = {'en'=>'value_en'} #column header row names of the csv with the category label in each language
      
      productToCategoriesFile = 'sample_data/product_categories.csv'; #a csv file with header row

      

      #add a csv file as main product file
      mainSourceKey = bxData.addMainCSVItemFile(mainProductFile, itemIdColumn)
      
      #add a csv file with products ids to categories ids
      productToCategoriesSourceKey = bxData.addCSVItemFile(productToCategoriesFile, itemIdColumn)
      
      #add a csv file with categories
      bxData.addCategoryFile(categoryFile, categoryIdColumn, parentCategoryIdColumn, categoryLabelColumns)
      
      #this part is only necessary to do when you push your data in full, as no specifications changes should not be published without a full data sync following next
      #even when you publish your data in full, you don't need to repush your data specifications if you know they didn't change, however, it is totally fine (and suggested) to push them everytime if you are not sure if something changed or not
      if(!isDelta) 

        #set the category field from the source mapping products to category ids (indicating which column of that file contains the category_id)
        bxData.setCategoryField(productToCategoriesSourceKey, categoryIdColumn)

        @logs.push("publish the data specifications")
        bxData.pushDataSpecifications()

        @logs.push("publish the api owner changes") #if the specifications have changed since the last time they were pushed
        bxData.publishChanges();
      end

      @logs.push("push the data for data sync")
      bxData.pushData()
      @message = @logs.join("<br/>")
      
    rescue Exception => e 

      #be careful not to print the error message on your publish web-site as sensitive information like credentials might be indicated for debug purposes
      @message =  e
      
    end
  end

  def backend_data_categories_xml
    require 'json'
    require 'BxData'
    require 'BxClient'
    #required parameters you should set for this example to work
    # @account = ""; # your account name
    # @password = ""; # your account password
    # @domain = "" # your web-site domain (e.g.: www.abc.com)
    # @languages = ['en'] #declare the list of available languages
    # @isDev = false #are the data to be pushed dev or prod data?
    # @isDelta = false #are the data to be pushed full data (reset index) or delta (add/modify index)?
    # @logs = Array.new #optional, just used here in example to collect logs
    bxData = BxData.new(BxClient.new(@account, @password, @domain) , @languages, @isDev, @isDelta)
    begin

      mainProductFile = 'sample_data/products.csv' #a csv file with header row
      itemIdColumn = 'id'; #the element of the xml with the unique id of each item
      productsXPath = '/products/product'; #path from the root to the products

      categoryFile = 'sample_data/categories.csv' #a csv file with header row
      categoryIdColumn = 'category_id' #column header row name of the csv with the unique category id
      parentCategoryIdColumn = 'parent_id' #column header row name of the csv with the parent category id
      categoryLabelColumns = {'en'=>'value_en'} #column header row names of the csv with the category label in each language
      
      categoriesXPath = '/categories/category' #path from the root to the categories

      productCategoryFile = 'sample_data/product_categories.xml' #xml file of all the product to category mapping
      productCategoryXPath = '/category_products/category_product' #path from the root to the product category mapping

      #add a xml file as main product file
      sourceKey = bxData.addMainXMLItemFile(mainProductFile, itemIdColumn, productsXPath)

      #add a xml file with products ids to categories ids
      $productToCategoriesSourceKey = bxData.addXMLItemFile(productCategoryFile, itemIdColumn, productCategoryXPath)

      #add a xml file with categories
      bxData.addXMLCategoryFile(categoryFile, categoryIdColumn, parentCategoryIdColumn, categoryLabelColumns, categoriesXPath)

      #this part is only necessary to do when you push your data in full, as no specifications changes should not be published without a full data sync following next
      #even when you publish your data in full, you don't need to repush your data specifications if you know they didn't change, however, it is totally fine (and suggested) to push them everytime if you are not sure if something changed or not
      if(!isDelta) 

        #set the category field from the source mapping products to category ids (indicating which column of that file contains the category_id)
        bxData.setCategoryField(productToCategoriesSourceKey, categoryIdColumn)

        @logs.push("publish the data specifications")
        bxData.pushDataSpecifications()

        @logs.push("publish the api owner changes") #if the specifications have changed since the last time they were pushed
        bxData.publishChanges()
      end

      @logs.push("push the data for data sync")
      bxData.pushData()
      @message = @logs.join("<br/>")
      
    rescue Exception => e 

      #be careful not to print the error message on your publish web-site as sensitive information like credentials might be indicated for debug purposes
      @message =  e
      
    end
  end

  def backend_data_customers
    require 'json'
    require 'BxData'
    require 'BxClient'
    #required parameters you should set for this example to work
    # @account = ""; # your account name
    # @password = ""; # your account password
    # @domain = "" # your web-site domain (e.g.: www.abc.com)
    # @languages = ['en'] #declare the list of available languages
    # @isDev = false #are the data to be pushed dev or prod data?
    # @isDelta = false #are the data to be pushed full data (reset index) or delta (add/modify index)?
    # @logs = Array.new #optional, just used here in example to collect logs
    bxData = BxData.new(BxClient.new(@account, @password, @domain) , @languages, @isDev, @isDelta)
    begin

      productFile = 'sample_data/products.csv' #a csv file with header row
      itemIdColumn = 'id' #the column header row name of the csv with the unique id of each item
      
      customerFile = 'sample_data/customers.csv' #a csv file with header row
      customerIdColumn = 'customer_id' #the column header row name of the csv with the unique id of each item
      
      #add a csv file as main product file
      bxData.addMainCSVItemFile(productFile, itemIdColumn)
      
      #add a csv file as main customer file
      customerSourceKey = bxData.addMainCSVCustomerFile(customerFile, customerIdColumn)
      
      #this part is only necessary to do when you push your data in full, as no specifications changes should not be published without a full data sync following next
      #even when you publish your data in full, you don't need to repush your data specifications if you know they didn't change, however, it is totally fine (and suggested) to push them everytime if you are not sure if something changed or not
      if(!isDelta) 

        bxData.addSourceStringField(customerSourceKey, "country", "country")
        bxData.addSourceStringField(customerSourceKey, "zip", "zip")

        @logs.push("publish the data specifications")
        bxData.pushDataSpecifications()

        @logs.push("publish the api owner changes") #if the specifications have changed since the last time they were pushed
        bxData.publishChanges()
      end

      @logs.push("push the data for data sync")
      bxData.pushData()
      @message = @logs.join("<br/>")
      
    rescue Exception => e 

      #be careful not to print the error message on your publish web-site as sensitive information like credentials might be indicated for debug purposes
      @message =  e
      
    end
  end

  def backend_data_debug_xml
    require 'json'
    require 'BxData'
    require 'BxClient'
    #required parameters you should set for this example to work
    # @account = ""; # your account name
    # @password = ""; # your account password
    # @domain = "" # your web-site domain (e.g.: www.abc.com)
    # @languages = ['en'] #declare the list of available languages
    # @isDev = false #are the data to be pushed dev or prod data?
    # @isDelta = false #are the data to be pushed full data (reset index) or delta (add/modify index)?
    # @logs = Array.new #optional, just used here in example to collect logs
    bxData = BxData.new(BxClient.new(@account, @password, @domain) , @languages, @isDev, @isDelta)
    begin

      productFile = 'sample_data/products.csv' #a csv file with header row
      itemIdColumn = 'id' #the column header row name of the csv with the unique id of each item
      
      #add a csv file as main product file
      sourceKey = bxData.addMainCSVItemFile(productFile, itemIdColumn)
      
      #declare the fields
      bxData.addSourceTitleField(sourceKey, {"en"=>"name_en"})
      bxData.addSourceDescriptionField(sourceKey, {"en"=>"description_en"})
      bxData.addSourceListPriceField(sourceKey, "list_price")
      bxData.addSourceDiscountedPriceField(sourceKey, "discounted_price")
      bxData.addSourceLocalizedTextField(sourceKey, "short_description", {"en"=>"short_description_en"})
      bxData.addSourceStringField(sourceKey, "sku", "sku")
      

      
      @message = bxData.getXML()
      
    rescue Exception => e 

      #be careful not to print the error message on your publish web-site as sensitive information like credentials might be indicated for debug purposes
      @message =  e
      
    end
  end

  def backend_data_full_export
    require 'json'
    require 'BxData'
    require 'BxClient'

    #required parameters you should set for this example to work
    # @account = ""; # your account name
    # @password = ""; # your account password
    # @domain = "" # your web-site domain (e.g.: www.abc.com)
    # @languages = ['en'] #declare the list of available languages
    # @isDev = false #are the data to be pushed dev or prod data?
    # @isDelta = false #are the data to be pushed full data (reset index) or delta (add/modify index)?
    # @logs = Array.new #optional, just used here in example to collect logs
    bxData = BxData.new(BxClient.new(@account, @password, @domain) , @languages, @isDev, @isDelta)
    begin

      #Product export
      file = 'sample_data/products.csv' #a csv file with header row
      itemIdColumn = 'id' #the column header row name of the csv with the unique id of each item
      colorFile = 'sample_data/color.csv' #a csv file with header row
      colorIdColumn = 'color_id' #column header row name of the csv with the unique category id
      colorLabelColumns = {'en'=>'value_en'}  #column header row names of the csv with the category label in each language
      productToColorsFile = 'sample_data/product_color.csv' #a csv file with header row

      #add a csv file as main product file
      sourceKey = bxData.addMainCSVItemFile(file, itemIdColumn)
      bxData.addSourceStringField(sourceKey, "related_product_ids", "related_product_ids")
      bxData.addFieldParameter(sourceKey, "related_product_ids", "splitValues", ",")

      #declare the fields
      bxData.addSourceTitleField(sourceKey, {"en"=>"name_en"})
      bxData.addSourceDescriptionField(sourceKey, {"en"=>"description_en"})
      bxData.addSourceListPriceField(sourceKey, "list_price")
      bxData.addSourceDiscountedPriceField(sourceKey, "discounted_price")
      bxData.addSourceLocalizedTextField(sourceKey, "short_description", {"en"=>"short_description_en"})
      bxData.addSourceStringField(sourceKey, "sku", "sku")

      #add a csv file with products ids to Colors ids
      productToColorsSourceKey = bxData.addCSVItemFile(productToColorsFile, itemIdColumn)

      #add a csv file with Colors
      colorSourceKey = bxData.addResourceFile(colorFile, colorIdColumn, colorLabelColumns)
      bxData.addSourceLocalizedTextField(productToColorsSourceKey, "color", colorIdColumn,colorSourceKey)


      #Category export
      categoryFile = 'sample_data/categories.csv' #a csv file with header row
      categoryIdColumn = 'category_id' #column header row name of the csv with the unique category id
      parentCategoryIdColumn = 'parent_id' #column header row name of the csv with the parent category id
      categoryLabelColumns = {'en'=>'value_en'} #column header row names of the csv with the category label in each language
      productToCategoriesFile = 'sample_data/product_categories.csv' #a csv file with header row

      #add a csv file with products ids to categories ids
      productToCategoriesSourceKey = bxData.addCSVItemFile(productToCategoriesFile, itemIdColumn)

      #//add a csv file with categories
      bxData.addCategoryFile(categoryFile, categoryIdColumn, parentCategoryIdColumn, categoryLabelColumns)
      bxData.setCategoryField(productToCategoriesSourceKey, categoryIdColumn)

      #Customer export
      customerFile = 'sample_data/customers.csv' #a csv file with header row
      customerIdColumn = 'customer_id' #the column header row name of the csv with the unique id of each item

      #add a csv file as main customer file
      customerSourceKey = bxData.addMainCSVCustomerFile(customerFile, customerIdColumn)
      bxData.addSourceStringField(customerSourceKey, "country", "country")
      bxData.addSourceStringField(customerSourceKey, "zip", "zip")

      #Transaction export
      transactionFile = '../sample_data/transactions.csv' #a csv file with header row, this file should contain one entry per product and per transaction (so the same transaction should appear several time if it contains more than 1 product
      orderIdColumn = 'order_id' #the column header row name of the csv with the order (or transaction) id
      transactionProductIdColumn = 'product_id' #the column header row name of the csv with the product id
      transactionCustomerIdColumn = 'customer_id' #the column header row name of the csv with the customer id
      orderDateIdColumn = 'order_date' #the column header row name of the csv with the order date
      totalOrderValueColumn = 'total_order_value' #the column header row name of the csv with the total order value
      productListPriceColumn = 'price' #the column header row name of the csv with the product list price
      productDiscountedPriceColumn = 'discounted_price' #the column header row name of the csv with the product price after discounts (real price paid)

      #optional fields, provided here with default values (so, no effect if not provided), matches the field to connect to the transaction product id and customer id columns (if the ids are not the same as the itemIdColumn of your products and customers files, then you can define another field)
      transactionProductIdField = 'bx_item_id' #default value (can be left null) to define a specific field to map with the product id column
      transactionCustomerIdField = 'bx_customer_id' #default value (can be left null) to define a specific field to map with the product id column

      #add a csv file as main customer file
      bxData.setCSVTransactionFile(transactionFile, orderIdColumn, transactionProductIdColumn, transactionCustomerIdColumn, orderDateIdColumn, totalOrderValueColumn, productListPriceColumn, productDiscountedPriceColumn, transactionProductIdField, transactionCustomerIdField)

      #prepare autocomplete index
      bxData.prepareCorpusIndex()
      fields = ["products_color"]
      bxData.prepareAutocompleteIndex(fields)

      @logs.push("publish the data specifications")
      bxData.pushDataSpecifications()

      @logs.push("publish the api owner changes") #if the specifications have changed since the last time they were pushed
      bxData.publishChanges()

      @logs.push("push the data for data sync")
      bxData.pushData()
      
    rescue Exception => e 

      #be careful not to print the error message on your publish web-site as sensitive information like credentials might be indicated for debug purposes
      @message =  e
      
    end
  end

  def backend_data_init
    require 'json'
    require 'BxData'
    require 'BxClient'
    #required parameters you should set for this example to work
    # @account = ""; # your account name
    # @password = ""; # your account password
    # @domain = "" # your web-site domain (e.g.: www.abc.com)
    # @languages = ['en'] #declare the list of available languages
    # @isDev = false #are the data to be pushed dev or prod data?
    # @isDelta = false #are the data to be pushed full data (reset index) or delta (add/modify index)?
    # @logs = Array.new #optional, just used here in example to collect logs
    bxData = BxData.new(BxClient.new(@account, @password, @domain) , @languages, @isDev, @isDelta)
    begin

      #/**
      #* Publish choices
      #*/
      #//your choie configuration can be generated in 3 possible ways: dev (using dev data), prod (using prod data as on your live web-site), prod-test (using prod data but not affecting your live web-site)
      isTest = false
      @logs.push("force the publish of your choices configuration: it does it either for dev or prod (above "+@isDev.to_s+" parameter) and, if isDev is false, you can do it in prod or prod-test<br>")
      bxData.publishChoices(isTest)
      
      #/**
      #* Prepare corpus index
      #*/
      @logs.push("force the preparation of a corpus index based on all the terms of the last data you sent ==> you need to have published your data before and you will need to publish them again that the corpus is sent to the index<br>")
      bxData.prepareCorpusIndex()
      
      #/**
      #* Prepare autocomplete index
      #*/
      #//NOT YET READY NOTICE: prepareAutocompleteIndex doesn't add the fields yet even if you pass them to the function like in this example here (TODO), for now, you need to go in the data intelligence admin and set the fields manually. You can contact support@boxalino.com to do that.
      #//the autocomplete index is automatically filled with common searches done over time, but of course, before going live, you will not have any. While it is possible to load pre-existing search logs (contact support@boxalino.com to learn how, you can also define some fields which will be considered for the autocompletion anyway (e.g.: brand, product line, etc.).
      fields = ["products_color"]
      @logs.push("force the preparation of an autocompletion index based on all the terms of the last data you sent ==> you need to have published your data before and you will need to publish them again that the corpus is sent to the index<br>")
      bxData.prepareAutocompleteIndex(fields)
       @message = @logs.join('<br/>')
    rescue Exception => e

      #be careful not to print the error message on your publish web-site as sensitive information like credentials might be indicated for debug purposes
      @message =  e

    end
  end

  def backend_data_resource
    require 'json'
    require 'BxData'
    require 'BxClient'
    #required parameters you should set for this example to work
    # @account = ""; # your account name
    # @password = ""; # your account password
    # @domain = "" # your web-site domain (e.g.: www.abc.com)
     @languages = ['en'] #declare the list of available languages
    # @isDev = false #are the data to be pushed dev or prod data?
    # @isDelta = false #are the data to be pushed full data (reset index) or delta (add/modify index)?
    # @logs = Array.new #optional, just used here in example to collect logs
    bxData = BxData.new(BxClient.new(@account, @password, @domain) , @languages, @isDev, @isDelta)
    begin

      mainProductFile = 'sample_data/products.csv' #a csv file with header row
      itemIdColumn = 'id' #the column header row name of the csv with the unique id of each item
      
      colorFile = 'sample_data/color.csv' #a csv file with header row
      colorIdColumn = 'color_id' #column header row name of the csv with the unique category id
      colorLabelColumns = {'en'=>'value_en'} #column header row names of the csv with the category label in each language
      
      productToColorsFile = 'sample_data/product_color.csv' #a csv file with header row
      
      #//add a csv file as main product file
      mainSourceKey = bxData.addMainCSVItemFile(mainProductFile, itemIdColumn)
      
      #add a csv file with products ids to Colors ids
      productToColorsSourceKey = bxData.addCSVItemFile(productToColorsFile, itemIdColumn)
      
      #add a csv file with Colors
      colorSourceKey = bxData.addResourceFile(colorFile, colorIdColumn, colorLabelColumns)
      
      #this part is only necessary to do when you push your data in full, as no specifications changes should not be published without a full data sync following next
      #even when you publish your data in full, you don't need to repush your data specifications if you know they didn't change, however, it is totally fine (and suggested) to push them everytime if you are not sure if something changed or not
  
      if(!@isDelta)

        #declare the color field as a localized textual field with a resource source key
        bxData.addSourceLocalizedTextField(productToColorsSourceKey, "color", colorIdColumn, colorSourceKey)
        @xmlOut = '' #bxData.getXML()

        @logs.push("publish the data specifications")
        bxData.pushDataSpecifications();

        @logs.push("publish the api owner changes") #if the specifications have changed since the last time they were pushed
        bxData.publishChanges()

      end

      @logs.push("push the data for data sync")
      bxData.pushData()
      @message = @logs.join("<br/>")
      
    rescue Exception => e 

      #be careful not to print the error message on your publish web-site as sensitive information like credentials might be indicated for debug purposes
      @message =  e
      
    end
  end

  def backend_data_resource_xml
    require 'json'
    require 'BxData'
    require 'BxClient'
    #required parameters you should set for this example to work
    # @account = ""; # your account name
    # @password = ""; # your account password
    # @domain = "" # your web-site domain (e.g.: www.abc.com)
    # @languages = ['en'] #declare the list of available languages
    # @isDev = false #are the data to be pushed dev or prod data?
    # @isDelta = false #are the data to be pushed full data (reset index) or delta (add/modify index)?
    # @logs = Array.new #optional, just used here in example to collect logs
    bxData = BxData.new(BxClient.new(@account, @password, @domain) , @languages, @isDev, @isDelta)
    begin

      mainProductFile = 'sample_data/products.xml' #xml file of all the products
      itemIdColumn = 'id' #the element of the xml with the unique id of each item
      productsXPath = '/products/product' #path from the root to the products

      colorFile = 'sample_data/color.xml' #a xml file of all the colors
      colorIdColumn = 'color_id' #element of the xml with the unique color id
      colorLabelColumns =  array("en"=>"value/translation[@locale='en']") #the element of the xml with the category label in each language
      colorXPath = '/colors/color' #path from the root to the colors

      productToColorsFile = 'sample_data/product_color.xml' #xml file of all the product to color mapping
      productColorXPath = '/product_colors/product_color' #path from the root to the product color mapping

      #//add a xml file as main product file
      mainSourceKey = bxData.addMainXMLItemFile(mainProductFile, itemIdColumn, productsXPath)

      #add a xml file with products ids to Colors ids
      productToColorsSourceKey = bxData.addXMLItemFile(productToColorsFile, itemIdColumn, productColorXPath)

      #add a xml file with Colors
      colorSourceKey = bxData.addXMLResourceFile(colorFile, colorIdColumn, colorLabelColumns, colorXPath)

      #this part is only necessary to do when you push your data in full, as no specifications changes should not be published without a full data sync following next
      #even when you publish your data in full, you don't need to repush your data specifications if you know they didn't change, however, it is totally fine (and suggested) to push them everytime if you are not sure if something changed or not
  
      if(!isDelta) 

        #declare the color field as a localized textual field with a resource source key
        bxData.addSourceLocalizedTextField(productToColorsSourceKey, "color", colorIdColumn, colorSourceKey)

    

        @logs.push("publish the data specifications")
        bxData.pushDataSpecifications();

        @logs.push("publish the api owner changes") #if the specifications have changed since the last time they were pushed
        $bxData.publishChanges()
      end

      @logs.push("push the data for data sync")
      bxData.pushData()
      @message = @logs.join("<br/>")
      
    rescue Exception => e 

      #be careful not to print the error message on your publish web-site as sensitive information like credentials might be indicated for debug purposes
      @message =  e
      
    end
  end

  def backend_data_split_field_values
    require 'json'
    require 'BxData'
    require 'BxClient'
    #required parameters you should set for this example to work
    # @account = ""; # your account name
    # @password = ""; # your account password
    # @domain = "" # your web-site domain (e.g.: www.abc.com)
    # @languages = ['en'] #declare the list of available languages
    # @isDev = false #are the data to be pushed dev or prod data?
    # @isDelta = false #are the data to be pushed full data (reset index) or delta (add/modify index)?
    # @logs = Array.new #optional, just used here in example to collect logs
    bxData = BxData.new(BxClient.new(@account, @password, @domain) , @languages, @isDev, @isDelta)
    begin

      file = 'sample_data/products.csv' #a csv file with header row
      itemIdColumn = 'id' #the column header row name of the csv with the unique id of each item
      
      #add a csv file as main product file
      sourceKey = bxData.addMainCSVItemFile(file, itemIdColumn)
      
      #//this part is only necessary to do when you push your data in full, as no specifications changes should not be published without a full data sync following next
      #//even when you publish your data in full, you don't need to repush your data specifications if you know they didn't change, however, it is totally fine (and suggested) to push them everytime if you are not sure if something changed or not
      if(!isDelta) 

        #//declare the fields
        bxData.addSourceStringField(sourceKey, "related_product_ids", "related_product_ids")
        bxData.addFieldParameter(sourceKey, "related_product_ids", "splitValues", ",")

        @logs.push("publish the data specifications")
        bxData.pushDataSpecifications();

        @logs.push("publish the api owner changes") #if the specifications have changed since the last time they were pushed
        $bxData.publishChanges()
      end

      @logs.push("push the data for data sync")
      bxData.pushData()
      @message = @logs.join("<br/>")
      
    rescue Exception => e 

      #be careful not to print the error message on your publish web-site as sensitive information like credentials might be indicated for debug purposes
      @message =  e
      
    end
  end

  def backend_data_transactions
    require 'json'
    require 'BxData'
    require 'BxClient'
    #required parameters you should set for this example to work
    # @account = ""; # your account name
    # @password = ""; # your account password
    # @domain = "" # your web-site domain (e.g.: www.abc.com)
    # @languages = ['en'] #declare the list of available languages
    # @isDev = false #are the data to be pushed dev or prod data?
    # @isDelta = false #are the data to be pushed full data (reset index) or delta (add/modify index)?
    # @logs = Array.new #optional, just used here in example to collect logs
    bxData = BxData.new(BxClient.new(@account, @password, @domain) , @languages, @isDev, @isDelta)
    begin

      productFile = 'sample_data/products.csv' #a csv file with header row
      itemIdColumn = 'id' #the column header row name of the csv with the unique id of each item
      
      customerFile = 'sample_data/customers.csv' #a csv file with header row
      customerIdColumn = 'customer_id' #the column header row name of the csv with the unique id of each item
      
      transactionFile = 'sample_data/transactions.csv' #a csv file with header row, this file should contain one entry per product and per transaction (so the same transaction should appear several time if it contains more than 1 product
      orderIdColumn = 'order_id' #the column header row name of the csv with the order (or transaction) id
      transactionProductIdColumn = 'product_id' #the column header row name of the csv with the product id
      transactionCustomerIdColumn = 'customer_id' #the column header row name of the csv with the customer id
      orderDateIdColumn = 'order_date' #the column header row name of the csv with the order date
      totalOrderValueColumn = 'total_order_value' #the column header row name of the csv with the total order value
      productListPriceColumn = 'price' #the column header row name of the csv with the product list price
      productDiscountedPriceColumn = 'discounted_price' #the column header row name of the csv with the product price after discounts (real price paid)
      
      #//optional fields, provided here with default values (so, no effect if not provided), matches the field to connect to the transaction product id and customer id columns (if the ids are not the same as the itemIdColumn of your products and customers files, then you can define another field)
      transactionProductIdField = 'bx_item_id' #default value (can be left null) to define a specific field to map with the product id column
      transactionCustomerIdField = 'bx_customer_id' #default value (can be left null) to define a specific field to map with the product id column
      
      #//add a csv file as main product file
      bxData.addMainCSVItemFile(productFile, itemIdColumn)
      
      #//add a csv file as main customer file
      bxData.addMainCSVCustomerFile(customerFile, customerIdColumn)
      
      #//add a csv file as main customer file
      bxData.setCSVTransactionFile(transactionFile, orderIdColumn, transactionProductIdColumn, transactionCustomerIdColumn, orderDateIdColumn, totalOrderValueColumn, productListPriceColumn, productDiscountedPriceColumn, transactionProductIdField, transactionCustomerIdField)
      
      #//this part is only necessary to do when you push your data in full, as no specifications changes should not be published without a full data sync following next
      #//even when you publish your data in full, you don't need to repush your data specifications if you know they didn't change, however, it is totally fine (and suggested) to push them everytime if you are not sure if something changed or not
      if(!isDelta) 

        #//declare the fields
        bxData.addSourceStringField(sourceKey, "related_product_ids", "related_product_ids")
        bxData.addFieldParameter(sourceKey, "related_product_ids", "splitValues", ",")

        @logs.push("publish the data specifications")
        bxData.pushDataSpecifications();

        @logs.push("publish the api owner changes") #if the specifications have changed since the last time they were pushed
        bxData.publishChanges()
      end

      @logs.push("push the data for data sync")
      bxData.pushData()
      @message = @logs.join("<br/>")
      
    rescue Exception => e 

      #be careful not to print the error message on your publish web-site as sensitive information like credentials might be indicated for debug purposes
      @message =  e
      
    end
  end
end
