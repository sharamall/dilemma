require "./decrypter.rb"

class Main
  DAYS = %w[mani tyr woden thunor frigg saturnus sol]

  def start
    ciphers = load_ciphers
    DAYS.each do |day|
      puts "-------- #{day} --------"
      ciphers.each { |c| Decrypter.new("./#{day}", c).decrypt! }
      puts ""
    end
  end

  private

  def load_ciphers
    ciphers = []
    File.open("./ciphers.txt", "r") do |f|
      ciphers << f.readline.chomp until f.eof?
    end
    ciphers
  end
end

Main.new.start