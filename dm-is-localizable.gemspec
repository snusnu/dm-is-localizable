# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{dm-is-localizable}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Martin Gamsjaeger (snusnu)"]
  s.date = %q{2009-05-16}
  s.email = %q{gamsnjaga@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.textile"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.textile",
     "Rakefile",
     "VERSION",
     "features/dm-is-localizable.feature",
     "features/step_definitions/dm-is-localizable_steps.rb",
     "features/support/env.rb",
     "lib/dm-is-localizable.rb",
     "lib/dm-is-localizable/is/localizable.rb",
     "lib/dm-is-localizable/storage/language.rb",
     "lib/dm-is-localizable/storage/translation.rb",
     "spec/dm-is-localizable_spec.rb",
     "spec/fixtures/item.rb",
     "spec/spec.opts",
     "spec/spec_helper.rb"
  ]
  s.homepage = %q{http://github.com/snusnu/dm-is-localizable}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.3}
  s.summary = %q{Datamapper support for localization of content in multilanguage applications}
  s.test_files = [
    "spec/dm-is-localizable_spec.rb",
     "spec/fixtures/item.rb",
     "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<dm-core>, [">= 0.9.11"])
      s.add_runtime_dependency(%q<dm-is-remixable>, [">= 0.9.11"])
      s.add_runtime_dependency(%q<dm-validations>, [">= 0.9.11"])
    else
      s.add_dependency(%q<dm-core>, [">= 0.9.11"])
      s.add_dependency(%q<dm-is-remixable>, [">= 0.9.11"])
      s.add_dependency(%q<dm-validations>, [">= 0.9.11"])
    end
  else
    s.add_dependency(%q<dm-core>, [">= 0.9.11"])
    s.add_dependency(%q<dm-is-remixable>, [">= 0.9.11"])
    s.add_dependency(%q<dm-validations>, [">= 0.9.11"])
  end
end
