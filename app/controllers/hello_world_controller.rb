# frozen_string_literal: true

class HelloWorldController < ApplicationController
  layout "hello_world"
  before_action :skip_authorization

  def show
    @hello_world_props = { name: "Stranger" }
  end
end
