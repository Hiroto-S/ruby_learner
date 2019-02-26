require "open3"

RSpec.describe "section-1, part-1" do
  it "return 8760" do
    workshop = "#{ENV['HOME']}/.ruby_learner/workshop"
    stdout, stderr, status = Open3.capture3("ruby #{workshop}/lib/workplace.rb")
    expect { print "#{stdout}" }.to output("8760\n").to_stdout
  end
end
