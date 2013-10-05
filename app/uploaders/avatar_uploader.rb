# encoding: utf-8

class AvatarUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # Include the Sprockets helpers for Rails 3.1+ asset pipeline compatibility:
  # include Sprockets::Helpers::RailsHelper
  # include Sprockets::Helpers::IsolatedHelper

  # Choose what kind of storage to use for this uploader:
  #storage :file

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
    "/assets/fallback/" + [version_name, "default.png"].compact.join('_')
  end
  #

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:

  version :mini do
    process :resize_to_limit => [23, 23]
  end

  version :medium do
    process :resize_to_limit => [50, 50]
  end

  version :normal do
    process :resize_to_limit => [100, 100]
  end

  #def filename
    #if original_filename
      #@name ||= Digest::MD5.hexdigest(File.dirname(current_path))
      #"#{@name}.#{file.extension}"
    #end
  #end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

end
