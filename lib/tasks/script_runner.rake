desc "Runs an external ruby script"
task :rscript, [:arg1, :arg2] => [:environment] do |t, args|
  puts "running R!"
  filepath = Rails.root.join("lib", "external_scripts", "autovir.R")
  output = `Rscript #{filepath}  #{args[:arg1]} #{args[:arg2]}`
end
