shared_examples 'http code' do |code|
  it "returns #{code}" do
    expect(response.response_code).to eq(code)
  end
end

shared_examples 'json response with errors key containing' do |detail|
  it "returns an error #{detail}" do
    json = JSON.parse(response.body)
    expect(json).not_to be_empty
    expect(json).to include('errors')
    expect(json['errors'].first['detail']).to include(detail)
  end
end

shared_examples 'json response with source.pointer' do |source_pointer|
  it "returns an error containing source.pointer = #{source_pointer}" do
    json = JSON.parse(response.body)
    expect(json).not_to be_empty
    expect(json).to include('errors')
    expect(json['errors']).to include(include('source' => include('pointer' => source_pointer)))

    # expect(json['errors'].first['source']['pointer']).to include(source_pointer)
  end
end
