-- modules/CTOmodule/patches/v0_9_3_editor_ui_edit.lua

local taskEditor = CTOmodule.taskEditor
local actions = CTOmodule.actions

-- patch 0.9.3: UI edit mode, save+apply flow, delete, and feedback

local editorState = {
  currentTaskId = nil
}

-- === UI → Fill editor fields from store ===
function taskEditor.loadToEditor(taskId)
  local data = taskEditor.store[taskId]
  if not data then
    perror("TaskEditor: No task with ID " .. taskId)
    return
  end
  editorState.currentTaskId = taskId

  local root = g_ui.getRootWidget()
  if not root then return end

  root:recursiveGetChildById("taskIdField"):setText(taskId)
  root:recursiveGetChildById("intervalField"):setText(data.intervalMs)
  root:recursiveGetChildById("priorityField"):setText(data.priority)
  root:recursiveGetChildById("enabledCheck"):setChecked(data.enabled)
  root:recursiveGetChildById("actionField"):setText(data.action)

  taskEditor.setStatus("Editing task: " .. taskId)
end

-- === Save button: upsert + apply + clear ===
function taskEditor.saveFromEditor()
  local root = g_ui.getRootWidget()
  if not root then return end

  local taskId = root:recursiveGetChildById("taskIdField"):getText()
  local interval = tonumber(root:recursiveGetChildById("intervalField"):getText()) or 1000
  local priority = tonumber(root:recursiveGetChildById("priorityField"):getText()) or 0
  local enabled = root:recursiveGetChildById("enabledCheck"):isChecked()
  local action = root:recursiveGetChildById("actionField"):getText()

  if not taskId or taskId == "" then
    taskEditor.setStatus("Task ID cannot be empty")
    return
  end

  local ok = taskEditor.upsert(taskId, {
    intervalMs = interval,
    priority = priority,
    enabled = enabled,
    action = action
  }, true)

  if ok == false then
    taskEditor.setStatus("Error: Duplicate ID")
    return
  end

  taskEditor.save()
  taskEditor.applyToRuntime()
  taskEditor.setStatus("Saved + Applied: " .. taskId)

  editorState.currentTaskId = nil
  taskEditor.clearEditorFields()
  taskEditor.refreshTaskList()
end

-- === Delete from editor ===
function taskEditor.deleteFromEditor()
  local root = g_ui.getRootWidget()
  if not root then return end

  local taskId = root:recursiveGetChildById("taskIdField"):getText()
  if not taskId or taskId == "" then
    taskEditor.setStatus("No task selected")
    return
  end

  if not taskEditor.store[taskId] then
    taskEditor.setStatus("Task not found: " .. taskId)
    return
  end

  taskEditor.store[taskId] = nil
  taskEditor.save()
  taskEditor.applyToRuntime()

  taskEditor.setStatus("Deleted task: " .. taskId)
  taskEditor.clearEditorFields()
  taskEditor.refreshTaskList()
end

-- === Clear fields ===
function taskEditor.clearEditorFields()
  local root = g_ui.getRootWidget()
  if not root then return end
  root:recursiveGetChildById("taskIdField"):setText("")
  root:recursiveGetChildById("intervalField"):setText("")
  root:recursiveGetChildById("priorityField"):setText("")
  root:recursiveGetChildById("enabledCheck"):setChecked(false)
  root:recursiveGetChildById("actionField"):setText("")
end

-- === Feedback label ===
function taskEditor.setStatus(msg)
  local root = g_ui.getRootWidget()
  if not root then return end
  local label = root:recursiveGetChildById("taskEditorStatus")
  if label then
    label:setText(msg)
    label:show()
    addEvent(function() label:hide() end, 3000)
  end
end

-- === CLI test: create + apply demo ===
function taskEditor.demoTest()
  taskEditor.upsert("v093_demo", {
    intervalMs = 2000,
    priority = 1,
    enabled = true,
    action = "print_state"
  }, true)

  taskEditor.save()
  taskEditor.applyToRuntime()
  taskEditor.setStatus("Demo task v093_demo created and applied")

  print("[v0.9.3 demo] Task created: v093_demo")
  CTOmodule.actions.run("task_editor_list")
  CTOmodule.actions.run("tasks_list")
end

-- === CLI test: simulate runtime apply ===
function taskEditor._test_apply_runtime_sim()
  local simulated = {
    test_log = {},
    addTask = function(self, id, fn)
      table.insert(self.test_log, { id = id, fnType = type(fn) })
    end
  }

  local originalAdd = CTOmodule.tasks.add
  CTOmodule.tasks.add = function(id, fn)
    simulated:addTask(id, fn)
  end

  taskEditor.upsert("mock1", { intervalMs = 500, priority = 0, enabled = true, action = "mock_action" }, true)
  taskEditor.upsert("mock2", { intervalMs = 1000, priority = 0, enabled = false, action = "mock_action" }, true)
  taskEditor.save()
  taskEditor.applyToRuntime()

  CTOmodule.tasks.add = originalAdd

  print("[applyToRuntime test] Simulated log:")
  for _, entry in ipairs(simulated.test_log) do
    print("- " .. entry.id .. " (fnType: " .. entry.fnType .. ")")
  end

  return simulated.test_log
end

print("[TaskEditor v0.9.3] Editor UI edit mode + delete patch loaded.")
