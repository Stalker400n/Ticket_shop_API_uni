class SchemaValidator
  SCHEMA = JSONSchemer.schema(Rails.root.join("schemas/bilietai.schema.json"))

  def self.check(event)
    SCHEMA.validate({"bilietai" => [event]}).map{ |e| "#{e['data_pointer']}: #{e['error']}"}
  end
end
