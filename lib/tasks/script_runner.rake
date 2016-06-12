desc "Runs an external ruby script"
task :rscript, [:arg1, :arg2, :arg3, :arg4, :arg5, :arg6] => [:environment] do |t, args|
  puts "running R!"
  filepath = Rails.root.join("lib", "external_scripts", "autovir.R")
  output = `Rscript #{filepath}  #{args[:arg1]} #{args[:arg2]} #{args[:arg3]} #{args[:arg4]} #{args[:arg5]} #{args[:arg6]}`
end
