module R2Z2
  class Repair
    attr_accessor :repair

    def initialize
      @repair = YAML.load_file("#{Dir.pwd}/data/repair.yaml")
    end

    def update(hash)
      @repair = hash
      open("#{Dir.pwd}/data/repair.yaml", "w") { |f| f.write(repair.to_yaml) }
      return nil
    end
  end
end    
