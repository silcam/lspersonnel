class CSVImporter

  def self.import(filename, model, import_fields={})
    failed_records = []
    File.open(filename, 'r') do |csvfile|
      headers = csvfile.gets.split('|')
      headers.each_index { |i| headers[i] = dequote(headers[i]) }

      while line = csvfile.gets
        fields = {}
        farray = line.split('|')
        headers.each_index { |i| fields[headers[i]] = dequote(farray[i]) }

        params = {}
        import_fields.each_pair{ |model_sym, old_name| params[model_sym] = fields[old_name] }
        
        import_record = model.find_by(id: params[:id])
        import_record ||= model.new

        params = yield(params) if block_given?

        begin
            import_record.update params
        rescue => error
            failed_records << "Failed to import:\n  #{line}\n  Because #{error.message}\n"
        end
      end
    end
    failed_records.each{|line| p line}
  end

  def self.dequote(s)
    return if s.nil?
    s = s.chomp.chomp('"')
    s.slice!(0) if s[0] == '"'
    s
  end

  def self.extract_date(s, format)
    return if s.nil? || s.length < format.length
    y = s[format.index('yyyy')]
    m = s[format.index('mm')]
    d = s[format.index('dd')]
    return "#{y}-#{m}-#{d}"
  end
end
