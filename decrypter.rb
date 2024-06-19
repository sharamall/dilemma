require "./utils/utils.rb"
require "byebug" rescue nil

class Decrypter
  def initialize(dir, cipher)
    @dir = dir
    @cipher = cipher
  end

  def decrypt!
    return unless @cipher.include? "aes-256-cfb"
    lefts, rights = load_data

    lefts.each_with_index do |left, i|
      File.open("tmp.enc", "w") { |f| f.write(rights[i] + "\n") }
      cmd = "openssl #{@cipher} -nopad -d -a -in tmp.enc -a -k #{Utils::KEY} -iv #{left} -pbkdf2"
      puts "cmd: #{cmd}"
      result = `#{cmd}`
      unless ["bad decrypt", "error"].any? { |err| result.downcase.include? err }
        puts "#{i}: \"#{result.ord}\"" rescue "#{i}: \"#{result}\""
      end
    end
  rescue => e
    puts "Cannot decrypt dir #{@dir} with cipher #{@cipher} due to #{e.message}"
    byebug
  ensure
    File.delete "tmp.enc" rescue nil
  end

  private

  def load_data
    lefts = []
    rights = []
    File.open("#{@dir}/left.txt", "r") do |f|
      until f.eof?
        line = f.readline.chomp
        lefts << Utils::base64_to_hex(line) unless %w[left right].include?(line.downcase)
      end
    end
    File.open("#{@dir}/right.txt", "r") do |f|
      until f.eof?
        line = f.readline.chomp
        rights << line unless %w[left right].include?(line.downcase)
      end
    end

    [lefts.filter { |it| !it.empty? }, rights.filter { |it| !it.empty? }]
  end
end