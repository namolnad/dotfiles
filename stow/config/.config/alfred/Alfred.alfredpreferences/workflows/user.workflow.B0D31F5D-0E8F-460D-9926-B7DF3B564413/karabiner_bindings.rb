#!/usr/bin/env ruby
# frozen_string_literal: true

require 'json'

karabiner_path = File.expand_path('~/.config/karabiner/karabiner.json')

TARGET_SUBLAYERS = %w[hyper_sublayer_e hyper_sublayer_w].freeze

def relevant_to_hyper_sublayer?(manipulator)
  return false unless manipulator['conditions']

  manipulator['conditions'].any? do |cond|
    cond['type'] == 'variable_if' && TARGET_SUBLAYERS.include?(cond['name'])
  end
end

def extract_from(from)
  return 'unknown' unless from

  key = from['key_code'] || 'unknown'
  modifiers = from.dig('modifiers', 'mandatory') || []
  "#{modifiers.join(' + ')}#{modifiers.any? ? ' + ' : ''}#{key}"
end

def extract_to(to_array)
  return 'unknown' if to_array.nil? || to_array.empty?

  to_array.map do |to|
    if to['shell_command']
      "Shell: #{to['shell_command']}"
    elsif to['key_code']
      "Key: #{to['key_code']}"
    else
      'Other Action'
    end
  end.join(', ')
end

def parse_karabiner(json) # rubocop:disable Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/MethodLength
  items = []
  json['profiles'].each do |profile|
    next unless profile['complex_modifications']

    profile['complex_modifications']['rules'].each do |rule|
      rule['manipulators'].each do |manipulator|
        next unless relevant_to_hyper_sublayer?(manipulator)

        from = extract_from(manipulator['from'])
        to = extract_to(manipulator['to'])
        desc = manipulator['description'] || rule['description'] || 'Unnamed binding'

        items << {
          title: desc,
          subtitle: "#{from} → #{to}",
          arg: "#{from} → #{to}"
        }
      end
    end
  end
  items
end

karabiner_json = JSON.parse(File.read(karabiner_path))
bindings = parse_karabiner(karabiner_json)

query = (ARGV[0] || '').downcase

filtered_items = bindings.select do |item|
  item[:title].downcase.include?(query) || item[:subtitle].downcase.include?(query)
end

puts JSON.generate({ items: filtered_items })
