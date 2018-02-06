require 'sablon'
#require 'omnidocx'

class GeneratedDocument < ApplicationRecord

  FILES_DIRECTORY = "/app/helpers/documents/"
  FILENAMES = {
    first_request: "first_request.docx",
    new_primary_report: "new_primary_report.docx",
    permit_renew: "permit_renew.docx",
    second_primary_report: "second_primary_report.docx"
  }

  def self.first_request(person, tmpfile)
    template = Sablon.template(build_path(FILENAMES[:first_request]))

    # Context is dependant on file requested to be created.
    # But some things are common
    context = {
          # Where does this come from?
      minister_gender: 'Madame',
          # TODO: make it formattable in the
          # localization configurations.
      request_date: Date.today.strftime('%d %b %Y'),
      researcher_name: person.formal_name,
      researcher_name_short: person.formal_name_short,
          # Where does this come from?
      research_description: 'Research Description',
          # Where does this come from?
      future_activities: 'FUTR ACTIVTIES',
      adj_ending: person.adj_ending,
          # Where does this come form?
      request_period: 'un an',
      director_name: Director.current_director.name,
      director_title: Director.current_director.title
    }

    doc = generate(template, context, tmpfile)

    # This doesn't work -- not sure why.  Gem is probably busted.
    #Omnidocx::Docx.merge_documents(all_docs, new_output_path, true)

    doc
  end

  private

  def self.build_path(filename)
    base_path = File.expand_path("../../../", __FILE__)
    template_path = base_path + FILES_DIRECTORY + filename
  end

  def self.generate(template, context, tmpfile)
    output_path = tmpfile.path
    template.render_to_file(output_path, context)

    output_path
  end
end
