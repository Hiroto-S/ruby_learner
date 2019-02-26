require "open3"

RSpec.describe "section-1, part-2" do
  it "return 5258880" do
    workshop = "#{ENV['HOME']}/.ruby_learner/workshop"
    stdout, stderr, status = Open3.capture3("ruby #{workshop}/lib/workplace.rb")
    expect { print "#{stdout}" }.to output("5258880\n").to_stdout
  end
end
