module Utils
  module_function
  KEY = "6f8d9ee7e616c10e98bffc76bac502df2ed6ebb8ff26d16c3d822b33e6bc737b"

  def base64_to_hex(base64_string)
    base64_string.unpack('m*').first.unpack('H*').first
  end
end