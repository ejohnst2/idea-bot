# frozen_string_literal: true
require "shrine"
require 'image_processing/mini_magick'
require 'fastimage'

class ImageUploader < Shrine
  # plugins and uploading logic
  include ImageProcessing::MiniMagick

  plugin :determine_mime_type
  plugin :cached_attachment_data
  plugin :validation_helpers
  plugin :pretty_location

  plugin :store_dimensions, analyzer: -> (io, analyzers) do
    dimensions   = analyzers[:fastimage].call(io)   # try extracting dimensions with FastImage
    dimensions ||= analyzers[:mini_magick].call(io) # otherwise fall back to MiniMagick
    dimensions
  end
end
