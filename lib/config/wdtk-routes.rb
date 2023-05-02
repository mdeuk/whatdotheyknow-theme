# Here you can override or add to the pages in the core website

Rails.application.routes.draw do
  get '/england' => redirect('/body?tag=england', status: 302)
  get '/london' => redirect('/body?tag=london', status: 302)
  get '/scotland' => redirect('/body?tag=scotland', status: 302)
  get '/cymru' => redirect('/cy/body?tag=wales', status: 302)
  get '/wales' => redirect('/body?tag=wales', status: 302)
  get '/ni' => redirect('/body?tag=ni', status: 302)
  get '/northern-ireland' => redirect('/body?tag=ni', status: 302)

  get "/help/ico-guidance-for-authorities" => redirect("https://ico.org.uk/media/for-organisations/documents/how-to-disclose-information-safely-removing-personal-data-from-information-requests-and-datasets/2013958/how-to-disclose-information-safely.pdf"),
      as: :ico_guidance

  get "/help/ico-anonymisation-code" => redirect("https://ico.org.uk/media/1061/anonymisation-code.pdf"),
     as: :ico_anonymisation_code

  get "/how-have-you-used-wdtk" => redirect("https://survey.alchemer.com/s3/7276877/How-have-you-used-WDTK"),
     as: :how_have_you_used_wdtk

  get '/help/principles' => 'help#principles',
      as: :help_principles

  get '/help/house_rules' => 'help#house_rules',
      as: :help_house_rules

  get '/help/:house_rules_resolve' => redirect("/help/house_rules", status: 302),
        as: :help_house_rules_resolve,
        constraints: { house_rules_resolve: /conditions_of_use|site_rules|terms_and_conditions|terms_of_service|terms_of_use|the_legal_stuff|the_rules/ }
      
  get '/help/how' => 'help#how',
      as: :help_how

  get '/help/complaints' => 'help#complaints',
      as: :help_complaints

  get '/help/volunteers' => 'help#volunteers',
      as: :help_volunteers

  get '/help/beginners' => 'help#beginners',
      as: :help_beginners

  get '/help/ico_officers' => 'help#ico_officers',
      as: :help_ico_officers

  get '/help/glossary' => 'help#glossary',
      as: :help_glossary
  
  get '/help/environmental_information' => 'help#environmental_information',
      as: :help_environmental_information
end
