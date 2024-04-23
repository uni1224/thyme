class SearchesController < ApplicationController
        def search
            @word = params[:word]
            @users = User.looks(params[:search], @word)
          end
 
 end