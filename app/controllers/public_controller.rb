class PublicController < ApplicationController
  def contact_us
    @title = "Huge Selection of Shoes, Clothes, Bags & More. 24/7 Customer Service at BrandCruz!"
    @keywords = "Women's Shoes, Sale, Men's Shoes, Log In, Shipping and Returns"
    @description = "Free shipping BOTH ways on online shoes, clothing, and more! 60-day return policy, over 1000 brands, 24/7 friendly customer service."
    if request.get?
      @contact = ContactUs.new
    else
      @contact = ContactUs.new(contact_us_params)
      if @contact.save
        flash[:success] = 'Your contact request has been successfully submitted'
        redirect_to contact_us_path
      else
        flash[:success] = 'Please input required fields'
        render :contact_us
      end
    end
  end

  def about_us
    @title = "About Us - Brandcruz.com"
    @keywords = "brandcruz, Brand Cruz, Brandcruz.com"
    @description = "Brandcruz.com customers always get FAST, FREE Shipping and returns with NO order minimums and FREE 60-Day Returns!"
  end

  def domestic
    @title = "BrandCruz: Designer Apparel, Shoes, Handbags, & Beauty FREE SHIPPING"
    @keywords = "free shipping, coupon code, brand, cloth, shoes, women shoes"
    @description = "Free Shipping & Free Returns at Brandcruz.com. Shop the latest styles from top designers including Michael Kors, Tory Burch, Burberry, Christian Louboutin."
  end

  def international
    @title = "Brandcruz: Search and find the latest in fashion | Shipping Worldwide"
    @keywords = "Shoes, Dress, New to Sale, Designers,"
    @description = "FREE RETURNS & FREE 3-DAY SHIPPING WORLDWIDE -Women’s, Men’s Dresses, Handbags, Shoes, Jeans, Tops and more."
  end

  def privacy_policy

  end

  def term_condition

  end

  def safe_shopping_guarantee
    @title = "Brandcruz.com – Shop securely for Shoes, clothing, accessories and more on sale!"
    @keywords = "Women's Clothing, Sandals, Jackets & Coats, Women's Shoes"
    @description = "Discounted shoes, clothing, accessories and more at Brandcruz.com! Shop for brands you love on sale. Score on the Style, Score on the Price."
  end

  def secure_shopping
    @title = "Brandcruz.com - Up to 50% off luxury fashion‎ |Shop Secure"
    @keywords = "Sale, Shoes, Designers, Dresses, Clothing, Tops , Bags, porter"
    @description = "Shop designer fashion online at Brandcruz.com. Designer clothes, designer shoes, designer bags and designer accessories from top designer brands: ..."
  end

  def coupon
    @title = "Brandcruz.com coupon code – Brandcruz.com | FREE SHIPPING & RETURNS"
    @description = "Brandcruz.com coupon code available online, Promotion code for unbeatable discount"
    @keywords = "brandcruz.com coupon code, brandcruz, brandcruz.com"
  end

  def faq
    @title = "Shop Brandcruz.com  for the latest trends and the best deals | BrandCruz"
    @keywords = "Plus size, Men, Women’s sale, sale sale, sale, hello"
    @description = "Brandcruz.com is the authority on fashion & the go-to retailer for the latest trends, must-have styles & the hottest deals. Shop dresses, tops, tees, leggings & more."
  end

  def not_found
    respond_to do |format|
      format.html { render status: 404 }
      format.xml { render xml: {error: 'Not found'}, status: 404 }
      format.json { render json: {error: 'Not found'}, status: 404 }
    end
  end

  def internal_error

  end

  def unacceptable

  end

  def wishlist
    render layout: 'product'
  end


  private

  def contact_us_params
    params.require(:contact_us).permit!
  end
end
