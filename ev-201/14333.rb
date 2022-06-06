require 'yaml'

class LevelFourMilestone
  VALID_QUESTIONNAIRE_KEYS = ["kerb_mass",
    "drag_coefficient",
    "frontal_area",
    "air_density",
    "road_slope",
    "coefficient_of_friction",
    "energy_consumption_from_propulsion",
    "power_of_motor_selected",
    "energy_consumption_from_secondary_components",
    "total_energy_consumption",
    "range"]

  def initialize(event_data)
    @event_data = event_data
    @checklist = event_data['checklist']
  end

  def execute
    if @checklist != nil
      verify_submission(@event_data)
    else
      raise "Unexpected error: Could not find result in checklist"
    end
  end

  private

  def correct_submission?
    valid_questionnaire && valid_energy_consumption && valid_battery_selection
  end

  def verify_submission(submission_data)
    if correct_submission?
      { result: "pass", feedback: "Dear Student, Good Job. The energy consumption simulated by you is correct." }
    else
      { result: "failed", feedback: custom_feedback}
    end
  end

  def sanitize_responses(raw_data)
    return raw_data if raw_data.is_a? String

    raw_data.each_with_object({}) do |(key, value), result|
      result[key] = if value.is_a? String
        value.scan(/^\d+\.?\d+/)&.first.to_f
      elsif value.is_a? Integer
        value.to_f
      elsif value.is_a? Float
        value
      else
        99999999
      end
    end
  end

  def parsed_yaml_input
    result = @checklist.last["result"]
    begin
      sanitize_responses(YAML.safe_load(result))
    rescue
      ""
    end
  end

  def valid_questionnaire
    return false unless parsed_yaml_input.is_a? Hash

    submitted_keys = parsed_yaml_input.keys

    VALID_QUESTIONNAIRE_KEYS.all? { |value| submitted_keys.include? value }
  end

  def valid_energy_consumption
    vehicle_type = @checklist[0]["result"]
    wltp_class = @checklist[1]["result"]
    questionnaire = parsed_yaml_input

    road_slope = questionnaire['road_slope']
    energy_consumption_from_propulsion = questionnaire['energy_consumption_from_propulsion']

    if wltp_class == "Class 3"
      if vehicle_type == "2 wheeled" && road_slope == 0
        energy_consumption_from_propulsion.between?(25, 60)
      elsif vehicle_type == "2 wheeled" && road_slope > 0
        energy_consumption_from_propulsion.between?(35, 80)
      elsif vehicle_type == "4 wheeled" && road_slope == 0
        energy_consumption_from_propulsion.between?(30, 150)
      elsif vehicle_type == "4 wheeled" && road_slope > 0
        energy_consumption_from_propulsion.between?(100, 250)
      else
        false
      end
    elsif wltp_class == "Class 2" || wltp_class == "Class 1"
      energy_consumption_from_propulsion.between?(1, 25) && road_slope == 0 || energy_consumption_from_propulsion.between?(1, 60) && road_slope > 0
    else
      false
    end
  end

  def custom_feedback
    if valid_questionnaire
      if !valid_energy_consumption
        "Dear Student, It seems that your simulated energy consumption is incorrect. Please try again and resubmit."
      end
    else
      "There is something wrong with the submitted questionnaire. Please check the following: \n 1. All the values for the 11 parameters are given\n 2. There is a space between the colon(:) and inputted value for each of the parameter.\n 3. The supplied format is not changed for the questionnaire"
    end
  end
end


require 'json'
file = File.open("./submission.json")
data = JSON.load file
puts LevelFourMilestone.new(data).execute
