-------------------------------------------------------------------------------------------------------------------------------------------------------------
-- VEAF mission triggers injection tool for DCS World
-- By Zip (2021)
--
-- Features:
-- ---------
-- * This tool processes a mission and injects the triggers necessary to load a VEAF scripted mission.
-- * The triggers and associated data come from the triggers table
--
-- Prerequisite:
-- ------------
-- * The mission file archive must already be exploded ; the script only works on the mission files, not directly on the .miz archive
--
-- Basic Usage:
-- ------------
-- First, create 5 "MISSION START" triggers with a "LUA PREDICATE" condition, and a "DO SCRIPT" action, first in the mission triggers list.
-- Then call the script by running it in a lua environment ; it needs the veafMissionEditor library, so the script working directory must contain the veafMissionEditor.lua file
-- 
-- veafMissionTriggerInjector.lua <mission folder path> [-debug|-trace]
-- 
-- Command line options:
-- * <mission folder path> the path to the exploded mission files (no trailing backslash)
-- * -debug if set, the script will output some information ; useful to find out which units were edited
-- * -trace if set, the script will output a lot of information : useful to understand what went wrong
-------------------------------------------------------------------------------------------------------------------------------------------------------------
require("veafMissionEditor")

veafMissionTriggerInjector = {}

-------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Global settings. Stores the script constants
-------------------------------------------------------------------------------------------------------------------------------------------------------------

--- Identifier. All output in the log will start with this.
veafMissionTriggerInjector.Id = "MISSIONTRIGGERS_EDITOR - "

--- Version.
veafMissionTriggerInjector.Version = "1.0.0"

-- trace level, specific to this module
veafMissionTriggerInjector.Trace = false
veafMissionTriggerInjector.Debug = false

-------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Do not change anything below unless you know what you are doing!
-------------------------------------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Utility methods
-------------------------------------------------------------------------------------------------------------------------------------------------------------

function veafMissionTriggerInjector.logError(message)
    print(veafMissionTriggerInjector.Id .. message)
end

function veafMissionTriggerInjector.logInfo(message)
    print(veafMissionTriggerInjector.Id .. message)
end

function veafMissionTriggerInjector.logDebug(message)
  if message and veafMissionTriggerInjector.Debug then 
    print(veafMissionTriggerInjector.Id .. message)
  end
end

function veafMissionTriggerInjector.logTrace(message)
  if message and veafMissionTriggerInjector.Trace then 
    print(veafMissionTriggerInjector.Id .. message)
  end
end

-------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Data for injection -- do not change
-------------------------------------------------------------------------------------------------------------------------------------------------------------

veafMissionTriggerInjector.trig = {}

veafMissionTriggerInjector.trig.actions = {
    [1] = 'a_do_script(getValueDictByKey("DictKey_ActionText_10001"));a_do_script(getValueDictByKey("DictKey_ActionText_10002"));',
    [2] = 'a_do_script(getValueDictByKey("DictKey_ActionText_10101"));a_do_script(getValueDictByKey("DictKey_ActionText_10102"));a_do_script(getValueDictByKey("DictKey_ActionText_10103"));a_do_script(getValueDictByKey("DictKey_ActionText_10104"));a_do_script(getValueDictByKey("DictKey_ActionText_10105"));a_do_script(getValueDictByKey("DictKey_ActionText_10106"));a_do_script(getValueDictByKey("DictKey_ActionText_10107"));a_do_script(getValueDictByKey("DictKey_ActionText_10108"));',
    [3] = 'a_do_script(getValueDictByKey("DictKey_ActionText_10201"));a_do_script_file(getValueResourceByKey("DictKey_ActionText_10202"));a_do_script_file(getValueResourceByKey("DictKey_ActionText_10203"));a_do_script_file(getValueResourceByKey("DictKey_ActionText_10204"));a_do_script_file(getValueResourceByKey("DictKey_ActionText_10205"));a_do_script_file(getValueResourceByKey("DictKey_ActionText_10206"));a_do_script_file(getValueResourceByKey("DictKey_ActionText_10207"));a_do_script_file(getValueResourceByKey("DictKey_ActionText_10208"));a_do_script_file(getValueResourceByKey("DictKey_ActionText_10209"));a_do_script_file(getValueResourceByKey("DictKey_ActionText_10210"));a_do_script_file(getValueResourceByKey("DictKey_ActionText_10211"));a_do_script_file(getValueResourceByKey("DictKey_ActionText_10212"));a_do_script_file(getValueResourceByKey("DictKey_ActionText_10213"));a_do_script_file(getValueResourceByKey("DictKey_ActionText_10214"));a_do_script_file(getValueResourceByKey("DictKey_ActionText_10215"));a_do_script_file(getValueResourceByKey("DictKey_ActionText_10216"));a_do_script_file(getValueResourceByKey("DictKey_ActionText_10217"));a_do_script_file(getValueResourceByKey("DictKey_ActionText_10218"));a_do_script_file(getValueResourceByKey("DictKey_ActionText_10219"));a_do_script_file(getValueResourceByKey("DictKey_ActionText_10220"));a_do_script_file(getValueResourceByKey("DictKey_ActionText_10221"));a_do_script_file(getValueResourceByKey("DictKey_ActionText_10222"));a_do_script_file(getValueResourceByKey("DictKey_ActionText_10223"));a_do_script_file(getValueResourceByKey("DictKey_ActionText_10224"));a_do_script_file(getValueResourceByKey("DictKey_ActionText_10225"));a_do_script_file(getValueResourceByKey("DictKey_ActionText_10226"));a_do_script_file(getValueResourceByKey("DictKey_ActionText_10227"));a_do_script_file(getValueResourceByKey("DictKey_ActionText_10228"));a_do_script_file(getValueResourceByKey("DictKey_ActionText_10229"));',
    [4] = 'a_do_script(getValueDictByKey("DictKey_ActionText_10301"));',
    [5] = 'a_do_script_file(getValueResourceByKey("DictKey_ActionText_10401"));'
}

veafMissionTriggerInjector.trig.conditions = {
    [1] = 'return(c_predicate(getValueDictByKey("DictKey_ActionText_10501")) )',
    [2] = 'return(c_predicate(getValueDictByKey("DictKey_ActionText_10601")) )',
    [3] = 'return(c_predicate(getValueDictByKey("DictKey_ActionText_10701")) )',
    [4] = 'return(c_predicate(getValueDictByKey("DictKey_ActionText_10801")) )',
    [5] = 'return(c_predicate(getValueDictByKey("DictKey_ActionText_10901")) )'
}

veafMissionTriggerInjector.trigrules = {
    [1] = {
        ["actions"] = {
            [1] = {
                ["KeyDict_text"] = "DictKey_ActionText_10001",
                ["predicate"] = "a_do_script",
                ["text"] = "DictKey_ActionText_10001"
            }, -- end of [1]
            [2] = {
                ["KeyDict_text"] = "DictKey_ActionText_10002",
                ["predicate"] = "a_do_script",
                ["text"] = "DictKey_ActionText_10002"
            } -- end of [2]
        }, -- end of ["actions"]
        ["colorItem"] = "0x00ffffff",
        ["comment"] = "choose - static or dynamic)",
        ["eventlist"] = "",
        ["predicate"] = "triggerStart",
        ["rules"] = {
            [1] = {
                ["flag"] = 1,
                ["KeyDict_text"] = "DictKey_ActionText_10501",
                ["predicate"] = "c_predicate",
                ["text"] = "DictKey_ActionText_10501"
            } -- end of [1]
        } -- end of ["rules"]
    }, -- end of [1]
    [2] = {
        ["actions"] = {
            [1] = {
                ["KeyDict_text"] = "DictKey_ActionText_10101",
                ["predicate"] = "a_do_script",
                ["text"] = "DictKey_ActionText_10101"
            }, -- end of [1]
            [2] = {
                ["KeyDict_text"] = "DictKey_ActionText_10102",
                ["predicate"] = "a_do_script",
                ["text"] = "DictKey_ActionText_10102"
            }, -- end of [2]
            [3] = {
                ["KeyDict_text"] = "DictKey_ActionText_10103",
                ["predicate"] = "a_do_script",
                ["text"] = "DictKey_ActionText_10103"
            }, -- end of [3]
            [4] = {
                ["KeyDict_text"] = "DictKey_ActionText_10104",
                ["predicate"] = "a_do_script",
                ["text"] = "DictKey_ActionText_10104"
            }, -- end of [4]
            [5] = {
                ["KeyDict_text"] = "DictKey_ActionText_10105",
                ["predicate"] = "a_do_script",
                ["text"] = "DictKey_ActionText_10105"
            }, -- end of [5]
            [6] = {
                ["KeyDict_text"] = "DictKey_ActionText_10106",
                ["predicate"] = "a_do_script",
                ["text"] = "DictKey_ActionText_10106"
            }, -- end of [6]
            [7] = {
                ["KeyDict_text"] = "DictKey_ActionText_10107",
                ["predicate"] = "a_do_script",
                ["text"] = "DictKey_ActionText_10107"
            }, -- end of [7]
            [8] = {
                ["KeyDict_text"] = "DictKey_ActionText_10108",
                ["predicate"] = "a_do_script",
                ["text"] = "DictKey_ActionText_10108"
            } -- end of [8]
        }, -- end of ["actions"]
        ["colorItem"] = "0x00ff80ff",
        ["comment"] = "mission start - dynamic",
        ["eventlist"] = "",
        ["predicate"] = "triggerStart",
        ["rules"] = {
            [1] = {
                ["KeyDict_text"] = "DictKey_ActionText_10601",
                ["predicate"] = "c_predicate",
                ["text"] = "DictKey_ActionText_10601"
            } -- end of [1]
        } -- end of ["rules"]
    }, -- end of [2]
    [3] = {
        ["actions"] = {
            [1] = {
                ["KeyDict_text"] = "DictKey_ActionText_10201",
                ["predicate"] = "a_do_script",
                ["text"] = "DictKey_ActionText_10201"
            }, -- end of [1]
            [2] = {
                ["file"] = "DictKey_ActionText_10202",
                ["predicate"] = "a_do_script_file"
            }, -- end of [2]
            [3] = {
                ["file"] = "DictKey_ActionText_10203",
                ["predicate"] = "a_do_script_file"
            }, -- end of [3]
            [4] = {
                ["file"] = "DictKey_ActionText_10204",
                ["predicate"] = "a_do_script_file"
            }, -- end of [4]
            [5] = {
                ["file"] = "DictKey_ActionText_10205",
                ["predicate"] = "a_do_script_file"
            }, -- end of [5]
            [6] = {
                ["file"] = "DictKey_ActionText_10206",
                ["predicate"] = "a_do_script_file"
            }, -- end of [6]
            [7] = {
                ["file"] = "DictKey_ActionText_10207",
                ["predicate"] = "a_do_script_file"
            }, -- end of [7]
            [8] = {
                ["file"] = "DictKey_ActionText_10208",
                ["predicate"] = "a_do_script_file"
            }, -- end of [8]
            [9] = {
                ["file"] = "DictKey_ActionText_10209",
                ["predicate"] = "a_do_script_file"
            }, -- end of [9]
            [10] = {
                ["file"] = "DictKey_ActionText_10210",
                ["predicate"] = "a_do_script_file"
            }, -- end of [10]
            [11] = {
                ["file"] = "DictKey_ActionText_10211",
                ["predicate"] = "a_do_script_file"
            }, -- end of [11]
            [12] = {
                ["file"] = "DictKey_ActionText_10212",
                ["predicate"] = "a_do_script_file"
            }, -- end of [12]
            [13] = {
                ["file"] = "DictKey_ActionText_10213",
                ["predicate"] = "a_do_script_file"
            }, -- end of [13]
            [14] = {
                ["file"] = "DictKey_ActionText_10214",
                ["predicate"] = "a_do_script_file"
            }, -- end of [14]
            [15] = {
                ["file"] = "DictKey_ActionText_10215",
                ["predicate"] = "a_do_script_file"
            }, -- end of [15]
            [16] = {
                ["file"] = "DictKey_ActionText_10216",
                ["predicate"] = "a_do_script_file"
            }, -- end of [16]
            [17] = {
                ["file"] = "DictKey_ActionText_10217",
                ["predicate"] = "a_do_script_file"
            }, -- end of [17]
            [18] = {
                ["file"] = "DictKey_ActionText_10218",
                ["predicate"] = "a_do_script_file"
            }, -- end of [18]
            [19] = {
                ["file"] = "DictKey_ActionText_10219",
                ["predicate"] = "a_do_script_file"
            }, -- end of [19]
            [20] = {
                ["file"] = "DictKey_ActionText_10220",
                ["predicate"] = "a_do_script_file"
            }, -- end of [20]
            [21] = {
                ["file"] = "DictKey_ActionText_10221",
                ["predicate"] = "a_do_script_file"
            }, -- end of [21]
            [22] = {
                ["file"] = "DictKey_ActionText_10222",
                ["predicate"] = "a_do_script_file"
            }, -- end of [22]
            [23] = {
                ["file"] = "DictKey_ActionText_10223",
                ["predicate"] = "a_do_script_file"
            }, -- end of [23]
            [24] = {
                ["file"] = "DictKey_ActionText_10224",
                ["predicate"] = "a_do_script_file"
            }, -- end of [24]
            [25] = {
                ["file"] = "DictKey_ActionText_10225",
                ["predicate"] = "a_do_script_file"
            }, -- end of [25]
            [26] = {
                ["file"] = "DictKey_ActionText_10226",
                ["predicate"] = "a_do_script_file"
            }, -- end of [26]
            [27] = {
                ["file"] = "DictKey_ActionText_10227",
                ["predicate"] = "a_do_script_file"
            }, -- end of [27]
            [28] = {
                ["file"] = "DictKey_ActionText_10228",
                ["predicate"] = "a_do_script_file"
            }, -- end of [28]
            [29] = {
                ["file"] = "DictKey_ActionText_10229",
                ["predicate"] = "a_do_script_file"
            } -- end of [29]
        }, -- end of ["actions"]
        ["colorItem"] = "0x00ff80ff",
        ["comment"] = "mission start - static",
        ["eventlist"] = "",
        ["predicate"] = "triggerStart",
        ["rules"] = {
            [1] = {
                ["KeyDict_text"] = "DictKey_ActionText_10701",
                ["predicate"] = "c_predicate",
                ["text"] = "DictKey_ActionText_10701"
            } -- end of [1]
        } -- end of ["rules"]
    }, -- end of [3]
    [4] = {
        ["actions"] = {
            [1] = {
                ["KeyDict_text"] = "DictKey_ActionText_10301",
                ["predicate"] = "a_do_script",
                ["text"] = "DictKey_ActionText_10301"
            } -- end of [1]
        }, -- end of ["actions"]
        ["colorItem"] = "0x8080ffff",
        ["comment"] = "mission config - dynamic)",
        ["eventlist"] = "",
        ["predicate"] = "triggerStart",
        ["rules"] = {
            [1] = {
                ["KeyDict_text"] = "DictKey_ActionText_10801",
                ["predicate"] = "c_predicate",
                ["text"] = "DictKey_ActionText_10801"
            } -- end of [1]
        } -- end of ["rules"]
    }, -- end of [4]
    [5] = {
        ["actions"] = {
            [1] = {
                ["file"] = "DictKey_ActionText_10401",
                ["predicate"] = "a_do_script_file"
            } -- end of [1]
        }, -- end of ["actions"]
        ["colorItem"] = "0x8080ffff",
        ["comment"] = "mission config - static",
        ["eventlist"] = "",
        ["predicate"] = "triggerStart",
        ["rules"] = {
            [1] = {
                ["KeyDict_text"] = "DictKey_ActionText_10901",
                ["predicate"] = "c_predicate",
                ["text"] = "DictKey_ActionText_10901"
            } -- end of [1]
        } -- end of ["rules"]
    } -- end of [5]
}

veafMissionTriggerInjector.dictionary = {
    ["DictKey_ActionText_10001"] = "VEAF_DYNAMIC_PATH = [[d:\\dev\\_VEAF\\VEAF-Mission-Creation-Tools]]",
    ["DictKey_ActionText_10002"] = "VEAF_DYNAMIC_MISSIONPATH = [[D:\\dev\\_VEAF\\VEAF-Open-Training-Mission\\]]",
    ["DictKey_ActionText_10101"] = 'env.info("DYNAMIC LOADING")',
    ["DictKey_ActionText_10102"] = 'assert(loadfile(VEAF_DYNAMIC_PATH .. "/src/scripts/community/mist.lua"))()',
    ["DictKey_ActionText_10103"] = 'assert(loadfile(VEAF_DYNAMIC_PATH .. "/src/scripts/community/Moose.lua"))()',
    ["DictKey_ActionText_10104"] = 'assert(loadfile(VEAF_DYNAMIC_PATH .. "/src/scripts/community/CTLD.lua"))()',
    ["DictKey_ActionText_10105"] = 'assert(loadfile(VEAF_DYNAMIC_PATH .. "/src/scripts/community/WeatherMark.lua"))()',
    ["DictKey_ActionText_10106"] = 'assert(loadfile(VEAF_DYNAMIC_PATH .. "/src/scripts/community/skynet-iads-compiled.lua"))()',
    ["DictKey_ActionText_10107"] = 'assert(loadfile(VEAF_DYNAMIC_PATH .. "/src/scripts/community/Hercules_Cargo.lua"))()',
    ["DictKey_ActionText_10108"] = 'assert(loadfile(VEAF_DYNAMIC_PATH .. "/src/scripts/VeafDynamicLoader.lua"))()',
    ["DictKey_ActionText_10201"] = 'env.info("STATIC LOADING")',
    ["DictKey_ActionText_10301"] = 'assert(loadfile(VEAF_DYNAMIC_MISSIONPATH .. "/src/scripts/missionConfig.lua"))()',
    ["DictKey_ActionText_10501"] = "return false -- set to true for dynamic loading",
    ["DictKey_ActionText_10601"] = "return VEAF_DYNAMIC_PATH~=nil",
    ["DictKey_ActionText_10701"] = "return VEAF_DYNAMIC_PATH==nil",
    ["DictKey_ActionText_10801"] = "return VEAF_DYNAMIC_PATH~=nil",
    ["DictKey_ActionText_10901"] = "return VEAF_DYNAMIC_PATH==nil"
}

veafMissionTriggerInjector.mapresource = {
    ["DictKey_ActionText_10202"] = "mist.lua",
    ["DictKey_ActionText_10203"] = "Moose.lua",
    ["DictKey_ActionText_10204"] = "CTLD.lua",
    ["DictKey_ActionText_10205"] = "WeatherMark.lua",
    ["DictKey_ActionText_10206"] = "skynet-iads-compiled.lua",
    ["DictKey_ActionText_10207"] = "Hercules_Cargo.lua",
    ["DictKey_ActionText_10208"] = "veaf.lua",
    ["DictKey_ActionText_10209"] = "veafRadio.lua",
    ["DictKey_ActionText_10210"] = "veafMarkers.lua",
    ["DictKey_ActionText_10211"] = "veafAssets.lua",
    ["DictKey_ActionText_10212"] = "veafSpawn.lua",
    ["DictKey_ActionText_10213"] = "veafCasMission.lua",
    ["DictKey_ActionText_10214"] = "veafCarrierOperations.lua",
    ["DictKey_ActionText_10215"] = "veafCarrierOperations2.lua",
    ["DictKey_ActionText_10216"] = "veafMove.lua",
    ["DictKey_ActionText_10217"] = "veafGrass.lua",
    ["DictKey_ActionText_10218"] = "dcsUnits.lua",
    ["DictKey_ActionText_10219"] = "veafUnits.lua",
    ["DictKey_ActionText_10220"] = "veafTransportMission.lua",
    ["DictKey_ActionText_10221"] = "veafNamedPoints.lua",
    ["DictKey_ActionText_10222"] = "veafShortcuts.lua",
    ["DictKey_ActionText_10223"] = "veafSecurity.lua",
    ["DictKey_ActionText_10224"] = "veafInterpreter.lua",
    ["DictKey_ActionText_10225"] = "veafCombatZone.lua",
    ["DictKey_ActionText_10226"] = "veafCombatMission.lua",
    ["DictKey_ActionText_10227"] = "veafRemote.lua",
    ["DictKey_ActionText_10228"] = "veafSkynetIadsHelper.lua",
    ["DictKey_ActionText_10229"] = "veafSanctuary.lua",
    ["DictKey_ActionText_10401"] = "missionConfig.lua"
}

-------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Core methods
-------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Save copied tables in `copies`, indexed by original table.
local function _deepcopy(orig, copies)
    copies = copies or {}
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        if copies[orig] then
            copy = copies[orig]
        else
            copy = {}
            copies[orig] = copy
            for orig_key, orig_value in next, orig, nil do
                copy[_deepcopy(orig_key, copies)] = _deepcopy(orig_value, copies)
            end
            setmetatable(copy, _deepcopy(getmetatable(orig), copies))
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function veafMissionTriggerInjector.injectTriggersInMission(dataTable)
  local trig = dataTable["trig"]
  if not trig then return nil end

  -- insert the 5 needed actions (browse in reverse order because each item will be inserted at index #1)
  local actions = trig["actions"]
  if not actions then return nil end

  for i = #veafMissionTriggerInjector.trig.actions, 1, -1 do
    local action = veafMissionTriggerInjector.trig.actions[i]
    table.insert(actions, 1, action)
  end

  -- insert the 5 needed conditions (browse in reverse order because each item will be inserted at index #1)
  local conditions = trig["conditions"]
  if not conditions then return nil end

  for i = #veafMissionTriggerInjector.trig.conditions, 1, -1 do
    local condition = veafMissionTriggerInjector.trig.conditions[i]
    table.insert(conditions, 1, condition)
  end

  -- insert the 5 needed trigger rules (browse in reverse order because each item will be inserted at index #1)
  local trigrules = dataTable["trigrules"]
  if not trigrules then return nil end

  for i = #veafMissionTriggerInjector.trigrules, 1, -1 do
    local rule = veafMissionTriggerInjector.trigrules[i]
    table.insert(trigrules, 1, rule)
  end

  return dataTable

end

function veafMissionTriggerInjector.injectKeysInDictionary(dataTable)
  local dictionary = dataTable
  if not dictionary then return nil end

  -- add the required keys
  for key, value in pairs(veafMissionTriggerInjector.dictionary) do
    dictionary[key] = value
  end

  return dataTable

end

function veafMissionTriggerInjector.injectKeysInMapResource(dataTable)
  local mapresource = dataTable
  if not mapresource then return nil end

  -- add the required keys
  for key, value in pairs(veafMissionTriggerInjector.mapresource) do
    mapresource[key] = value
  end

  return dataTable

end

local function main(arg)
  veafMissionTriggerInjector.logDebug(string.format("#arg=%d",#arg))
  for i=0, #arg do
      veafMissionTriggerInjector.logDebug(string.format("arg[%d]=%s",i,arg[i]))
  end
  if #arg < 1 then 
      veafMissionTriggerInjector.logError("USAGE : veafMissionTriggerInjector.lua <mission folder path> [-debug|-trace]")
      return
  end

  local filePath = arg[1]
  local debug = arg[2] and arg[2]:upper() == "-DEBUG"
  local trace = arg[2] and arg[2]:upper() == "-TRACE"
  if debug or trace then
    veafMissionTriggerInjector.Debug = true
    veafMissionEditor.Debug = true
    if trace then 
      veafMissionTriggerInjector.Trace = true
      veafMissionEditor.Trace = true
    end
  else
    veafMissionTriggerInjector.Debug = false
    veafMissionEditor.Debug = false
    veafMissionTriggerInjector.Trace = false
    veafMissionEditor.Trace = false
  end

  -- inject the triggers in the `mission` file
  veafMissionTriggerInjector.logDebug(string.format("Processing `mission` at [%s]",filePath))
  local _filePath = filePath .. [[\mission]]
  local _processFunction = veafMissionTriggerInjector.injectTriggersInMission
  veafMissionEditor.editMission(_filePath, _filePath, "mission", _processFunction)
  veafMissionTriggerInjector.logDebug("`mission` edited")

  -- inject the new dictionary keys in the `dictionary` file
  veafMissionTriggerInjector.logDebug(string.format("Processing `dictionary` at [%s]",filePath))
  local _filePath = filePath .. [[\l10n\DEFAULT\dictionary]]
  local _processFunction = veafMissionTriggerInjector.injectKeysInDictionary
  veafMissionEditor.editMission(_filePath, _filePath, "dictionary", _processFunction)
  veafMissionTriggerInjector.logDebug("`dictionary` edited")

  -- inject the new dictionary keys in the `mapResource` file
  veafMissionTriggerInjector.logDebug(string.format("Processing `mapResource` at [%s]",filePath))
  local _filePath = filePath .. [[\l10n\DEFAULT\mapResource]]
  local _processFunction = veafMissionTriggerInjector.injectKeysInMapResource
  veafMissionEditor.editMission(_filePath, _filePath, "mapResource", _processFunction)
  veafMissionTriggerInjector.logDebug("`mapResource` edited")
end

main(arg)