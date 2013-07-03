require 'AipoMng'
require 'IcsToGcal'
require 'yaml'

yml = YAML.load_file "AtoGconfig.yaml"
mng = AipoMng.new(yml["aipoconfig"]["aipo_id"],
                  yml["aipoconfig"]["aipo_pw"])
itg = IcsToGcal.new(yml["gcalconfig"]["google_id"],
                    yml["gcalconfig"]["google_pw"],
                    yml["gcalconfig"]["google_calendar_name"],
                    mng.aipo_getIcs)
itg.import_gics
