# frozen_string_literal: true

# Write your code for the 'Grep' exercise in this file. Make the tests in
# `grep_test.rb` pass.
#
# To get started with TDD, see the `README.md` file in your
# `ruby/grep` directory.
module Grep
  def self.grep(pattern, flags, files)
    logger = make_logger(flags, multiple_files: files.size > 1)
    filter = make_filter(pattern, flags)

    files
      .map { |file_name| File.read_from_file_name(file_name) }
      .map { |file| filter.call(file) }
      .flat_map { |file| logger.to_proc.call(file) }
      .join("\n")
  end

  # returns a Grep::File method that prints itself to string
  # -n Prepend the line number and a colon (':') to each line in the output,
  #    placing the number after the file name (if present).
  # -l Output only the names of the files that contain at least one matching
  #    line.
  def self.make_logger(flags, multiple_files:)
    return :log_only_file_name if flags.include?("-l")

    return :log_file_name_and_line_number if flags.include?("-n") && multiple_files

    return :log_line_number if flags.include?("-n")

    return :log_file_name if multiple_files

    :log_only_line
  end

  # returns a filter which is a lambda, that accepts file name and its lines
  # -l Output only the names of the files that contain at least one matching
  #    line.
  # -i Match using a case-insensitive comparison.
  # -v Invert the program -- collect all lines that fail to match.
  # -x Search only for lines where the search string matches the entire line.
  def self.make_filter(pattern, flags)
    ignore_case = flags.include?("-i")

    line_predicate =
      if flags.include?("-x")
        make_equals_predicate(pattern, ignore_case:)
      else
        make_include_predicate(pattern, ignore_case:)
      end

    line_predicate = invert_predicate(line_predicate) if flags.include?("-v")

    ->(file) { file.filter(line_predicate, find_first_line: flags.include?("-l")) }
  end

  def self.make_equals_predicate(pattern, ignore_case:)
    if ignore_case
      ->(line) { line.equals_ignore_case?(pattern) }
    else
      ->(line) { line == pattern }
    end
  end

  def self.make_include_predicate(pattern, ignore_case:)
    if ignore_case
      ->(line) { line.include_ignore_case?(pattern) }
    else
      ->(line) { line.include?(pattern) }
    end
  end

  def self.invert_predicate(predicate)
    ->(x) { !predicate.call(x) }
  end

  Line = Struct.new(:number, :content, keyword_init: true) do
    def ==(other) = content == other.to_s
    def equals_ignore_case?(other) = content.downcase == other.downcase

    def include?(pattern) = content.include?(pattern.to_s)

    def include_ignore_case?(pattern)
      content.downcase.include?(pattern.to_s.downcase)
    end

    def to_s = content
  end

  File = Struct.new(:file_name, :lines, keyword_init: true) do
    def self.read_from_file_name(file_name)
      lines = ::File.read(file_name).lines.map.with_index(1) do |line, index|
        Line.new(number: index, content: line.chomp)
      end
      new(file_name:, lines:)
    end

    def name = file_name

    def filter(line_predicate, find_first_line:)
      matches = lines.select(&line_predicate)

      matches = matches.take(1) if find_first_line

      File.new(file_name:, lines: matches)
    end

    def log_only_file_name
      return [] if lines.none?

      [file_name]
    end

    def log_file_name_and_line_number
      lines.map { |line| "#{file_name}:#{line.number}:#{line.content}" }
    end

    def log_line_number
      lines.map { |line| "#{line.number}:#{line.content}" }
    end

    def log_file_name
      lines.map { |line| "#{file_name}:#{line.content}" }
    end

    def log_only_line
      lines.map(&:content)
    end
  end
end
