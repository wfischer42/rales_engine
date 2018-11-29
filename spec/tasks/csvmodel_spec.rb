require 'rails_helper'

describe "rake csvmodel:import", type: :task do
  it "preloads the Rails environment" do
    expect(task.prerequisites).to include "environment"
  end

  it "imports data from CSV file" do
    task.execute( {model_names: "Merchant"} )
    expect(Merchant.first.name).to eq("Schroeder-Jerde")
    expect(Merchant.count).to eq(100)
  end

  it "doesn't duplicate entries on multiple loads" do
    task.execute( {model_names: "Merchant"} )
    task.execute( {model_names: "Merchant"} )
    expect(Merchant.count).to eq(100)
  end

  it "skips invalid model inputs" do
    invalid = "NotAModel"
    expect { task.execute( {model_names: invalid} ) }
      .to output("'#{invalid}' is not a valid model. Skipping...\nAttempting database import from CSVs for models: [] \n").to_stdout
  end

end
