pfUI:RegisterModule("gui", function ()
  pfUI.gui = CreateFrame("Frame",nil,UIParent)

  pfUI.gui:RegisterEvent("PLAYER_ENTERING_WORLD");

  pfUI.gui:SetFrameStrata("DIALOG")
  pfUI.gui:SetWidth(480)
  pfUI.gui:SetHeight(320)
  pfUI.gui:Hide()

  pfUI.gui:SetBackdrop(pfUI.backdrop)
  pfUI.gui:SetBackdropColor(0,0,0,.75);
  pfUI.gui:SetPoint("CENTER",0,0)
  pfUI.gui:SetMovable(true)
  pfUI.gui:EnableMouse(true)
  pfUI.gui:SetScript("OnMouseDown",function()
      pfUI.gui:StartMoving()
    end)
  pfUI.gui:SetScript("OnMouseUp",function()
      pfUI.gui:StopMovingOrSizing()
    end)

  function pfUI.gui.SwitchTab(frame)
    local elements = { pfUI.gui.global, pfUI.gui.uf , pfUI.gui.bar, pfUI.gui.panel, pfUI.gui.tooltip }
    for _, hide in pairs(elements) do
      hide:Hide()
    end
    frame:Show()
  end

  function pfUI.gui.CreateConfig(parent, caption, category, config)
    -- parent object placement
    if parent.objectCount == nil then
      parent.objectCount = 1
    else
      parent.objectCount = parent.objectCount + 1
    end

    -- basic frame
    local frame = CreateFrame("Frame", nil, parent)
    frame:SetWidth(350)
    frame:SetHeight(25)
    frame:SetBackdrop(pfUI.backdrop_underline)
    frame:SetBackdropBorderColor(1,1,1,.25)
    frame:SetPoint("TOPLEFT", 25, parent.objectCount * -25)

    -- caption
    frame.caption = frame:CreateFontString("Status", "LOW", "GameFontNormal")
    frame.caption:SetFont("Interface\\AddOns\\pfUI\\fonts\\arial.ttf", 12, "OUTLINE")
    frame.caption:SetAllPoints(frame)
    frame.caption:SetFontObject(GameFontWhite)
    frame.caption:SetJustifyH("LEFT")
    frame.caption:SetText(caption)
    frame.configCategory = category
    frame.configEntry = config

    -- input field
    frame.input = CreateFrame("EditBox", nil, frame)
    frame.input:SetTextColor(.2,1.1,1)
    frame.input:SetJustifyH("RIGHT")

    frame.input:SetWidth(100)
    frame.input:SetHeight(20)
    frame.input:SetPoint("TOPRIGHT" , 0, 0)
    frame.input:SetFontObject(GameFontNormal)
    frame.input:SetAutoFocus(false)
    frame.input:SetText(category[config])
    frame.category = category
    frame.config = config
    frame.input:SetScript("OnEscapePressed", function(self)
      this:ClearFocus()
    end)

    frame.input:SetScript("OnEditFocusLost", function(self)
      this:GetParent().category[this:GetParent().config] = this:GetText()
    end)

    return frame
  end

  function pfUI.gui.UnlockFrames()
    local movable = { pfUI.minimap, pfUI.chat.left, pfUI.chat.right,
      pfUI.uf.player, pfUI.uf.target, pfUI.uf.targettarget, pfUI.uf.pet,
      pfUI.bars.shapeshift, pfUI.bars.bottomleft, pfUI.bars.bottomright,
      pfUI.bars.vertical, pfUI.bars.pet, pfUI.bars.bottom }

    if not pfUI.gitter then
      pfUI.gitter = CreateFrame("Frame", nil, UIParent)
      pfUI.gitter:SetFrameStrata("BACKGROUND")
      pfUI.gitter:SetPoint("TOPLEFT", 0, 0, "TOPLEFT")
      pfUI.gitter:SetPoint("BOTTOMRIGHT", 0, 0, "BOTTOMRIGHT")
      pfUI.gitter:SetBackdrop(pfUI.backdrop_gitter)
      pfUI.gitter:SetBackdropColor(0,0,0,1)
      pfUI.gitter:Hide()
    end

    if pfUI.gitter:IsShown() then
      pfUI.gitter:Hide()
    else
      pfUI.gitter:Show()
    end


    for _,frame in pairs(movable) do
      local frame = frame
      if not frame.drag then
        frame.drag = CreateFrame("Frame", nil, frame)
        frame.drag:SetAllPoints(frame)
        frame.drag:SetFrameStrata("DIALOG")
        frame.drag.bg = frame.drag:CreateTexture()
        frame.drag.bg:SetAllPoints(frame.drag)
        frame.drag.bg:SetTexture(.2,1,.8,1)
        frame.drag:SetAlpha(.25)
      end

      frame.drag:SetScript("OnMouseDown",function()
          frame:StartMoving()
        end)

      frame.drag:SetScript("OnMouseUp",function()
          frame:StopMovingOrSizing()
        end)
    
      if pfUI.gitter:IsShown() then
        frame:SetMovable(true)
        frame.drag:EnableMouse(true)
        frame.drag:Show()
      else
        frame:SetMovable(false)
        frame.drag:EnableMouse(false)
        frame.drag:Hide()
      end
    end
  end

  -- Global Settings
  pfUI.gui.global = CreateFrame("Frame", nil, pfUI.gui)
  pfUI.gui.global:SetWidth(400)
  pfUI.gui.global:SetHeight(320)

  pfUI.gui.global:SetBackdrop(pfUI.backdrop)
  pfUI.gui.global:SetBackdropColor(0,0,0,.50);
  pfUI.gui.global:SetPoint("RIGHT",0,0)

  pfUI.gui.global.switch = CreateFrame("Button", nil, pfUI.gui)
  pfUI.gui.global.switch:ClearAllPoints()
  pfUI.gui.global.switch:SetWidth(80)
  pfUI.gui.global.switch:SetHeight(20)
  pfUI.gui.global.switch:SetPoint("TOPLEFT", 0, 0)
  pfUI.gui.global.switch:SetBackdrop(pfUI.backdrop)
  pfUI.gui.global.switch.text = pfUI.gui.global.switch:CreateFontString("Status", "LOW", "GameFontNormal")
  pfUI.gui.global.switch.text:SetFont("Interface\\AddOns\\pfUI\\fonts\\arial.ttf", 9, "OUTLINE")
  pfUI.gui.global.switch.text:ClearAllPoints()
  pfUI.gui.global.switch.text:SetAllPoints(pfUI.gui.global.switch)
  pfUI.gui.global.switch.text:SetPoint("CENTER", 0, 0)
  pfUI.gui.global.switch.text:SetFontObject(GameFontWhite)
  pfUI.gui.global.switch.text:SetText("Global")
  pfUI.gui.global.switch:SetScript("OnClick", function()
      pfUI.gui.SwitchTab(pfUI.gui.global)
    end)

  pfUI.gui.global.title = pfUI.gui.global:CreateFontString("Status", "LOW", "GameFontNormal")
  pfUI.gui.global.title:SetFont("Interface\\AddOns\\pfUI\\fonts\\arial.ttf", 12, "OUTLINE")
  pfUI.gui.global.title:SetPoint("TOP", 0, -10)
  pfUI.gui.global.title:SetFontObject(GameFontWhite)
  pfUI.gui.global.title:SetText("Global Settings")

  -- UnitFrame settings
  pfUI.gui.uf = CreateFrame("Frame", nil, pfUI.gui)
  pfUI.gui.uf:SetWidth(400)
  pfUI.gui.uf:SetHeight(320)

  pfUI.gui.uf:SetBackdrop(pfUI.backdrop)
  pfUI.gui.uf:SetBackdropColor(0,0,0,.50);
  pfUI.gui.uf:SetPoint("RIGHT",0,0)

  pfUI.gui.uf.switch = CreateFrame("Button", nil, pfUI.gui)
  pfUI.gui.uf.switch:ClearAllPoints()
  pfUI.gui.uf.switch:SetWidth(80)
  pfUI.gui.uf.switch:SetHeight(20)
  pfUI.gui.uf.switch:SetPoint("TOPLEFT", 0, -20)
  pfUI.gui.uf.switch:SetBackdrop(pfUI.backdrop)
  pfUI.gui.uf.switch.text = pfUI.gui.uf.switch:CreateFontString("Status", "LOW", "GameFontNormal")
  pfUI.gui.uf.switch.text:SetFont("Interface\\AddOns\\pfUI\\fonts\\arial.ttf", 9, "OUTLINE")
  pfUI.gui.uf.switch.text:ClearAllPoints()
  pfUI.gui.uf.switch.text:SetAllPoints(pfUI.gui.uf.switch)
  pfUI.gui.uf.switch.text:SetPoint("CENTER", 0, 0)
  pfUI.gui.uf.switch.text:SetFontObject(GameFontWhite)
  pfUI.gui.uf.switch.text:SetText("UnitFrames")
  pfUI.gui.uf.switch:SetScript("OnClick", function()
      pfUI.gui.SwitchTab(pfUI.gui.uf)
    end)

  pfUI.gui.uf.title = pfUI.gui.uf:CreateFontString("Status", "LOW", "GameFontNormal")
  pfUI.gui.uf.title:SetFont("Interface\\AddOns\\pfUI\\fonts\\arial.ttf", 12, "OUTLINE")
  pfUI.gui.uf.title:SetPoint("TOP", 0, -10)
  pfUI.gui.uf.title:SetFontObject(GameFontWhite)
  pfUI.gui.uf.title:SetText("UnitFrame Settings")

  pfUI.gui.CreateConfig(pfUI.gui.uf, "Animation speed", pfUI_config.unitframes, "animation_speed")
  pfUI.gui.CreateConfig(pfUI.gui.uf, "Show portrait", pfUI_config.unitframes, "portrait")
  pfUI.gui.CreateConfig(pfUI.gui.uf, "Buff size", pfUI_config.unitframes, "buff_size")
  pfUI.gui.CreateConfig(pfUI.gui.uf, "Debuff size", pfUI_config.unitframes, "debuff_size")
  pfUI.gui.CreateConfig(pfUI.gui.uf, "Layout", pfUI_config.unitframes, "layout")

  pfUI.gui.CreateConfig(pfUI.gui.uf, "Player width", pfUI_config.unitframes.player, "width")
  pfUI.gui.CreateConfig(pfUI.gui.uf, "Player height", pfUI_config.unitframes.player, "height")
  pfUI.gui.CreateConfig(pfUI.gui.uf, "Player powerbar height", pfUI_config.unitframes.player, "pheight")

  pfUI.gui.CreateConfig(pfUI.gui.uf, "Target width", pfUI_config.unitframes.target, "width")
  pfUI.gui.CreateConfig(pfUI.gui.uf, "Target height", pfUI_config.unitframes.target, "height")
  pfUI.gui.CreateConfig(pfUI.gui.uf, "Target powerbar height", pfUI_config.unitframes.target, "pheight")


  -- ActionBar settings
  pfUI.gui.bar = CreateFrame("Frame", nil, pfUI.gui)
  pfUI.gui.bar:SetWidth(400)
  pfUI.gui.bar:SetHeight(320)

  pfUI.gui.bar:SetBackdrop(pfUI.backdrop)
  pfUI.gui.bar:SetBackdropColor(0,0,0,.50);
  pfUI.gui.bar:SetPoint("RIGHT",0,0)

  pfUI.gui.bar.switch = CreateFrame("Button", nil, pfUI.gui)
  pfUI.gui.bar.switch:ClearAllPoints()
  pfUI.gui.bar.switch:SetWidth(80)
  pfUI.gui.bar.switch:SetHeight(20)
  pfUI.gui.bar.switch:SetPoint("TOPLEFT", 0, -40)
  pfUI.gui.bar.switch:SetBackdrop(pfUI.backdrop)
  pfUI.gui.bar.switch.text = pfUI.gui.bar.switch:CreateFontString("Status", "LOW", "GameFontNormal")
  pfUI.gui.bar.switch.text:SetFont("Interface\\AddOns\\pfUI\\fonts\\arial.ttf", 9, "OUTLINE")
  pfUI.gui.bar.switch.text:ClearAllPoints()
  pfUI.gui.bar.switch.text:SetAllPoints(pfUI.gui.bar.switch)
  pfUI.gui.bar.switch.text:SetPoint("CENTER", 0, 0)
  pfUI.gui.bar.switch.text:SetFontObject(GameFontWhite)
  pfUI.gui.bar.switch.text:SetText("ActionBars")
  pfUI.gui.bar.switch:SetScript("OnClick", function()
      pfUI.gui.SwitchTab(pfUI.gui.bar)
    end)

  pfUI.gui.bar.title = pfUI.gui.bar:CreateFontString("Status", "LOW", "GameFontNormal")
  pfUI.gui.bar.title:SetFont("Interface\\AddOns\\pfUI\\fonts\\arial.ttf", 12, "OUTLINE")
  pfUI.gui.bar.title:SetPoint("TOP", 0, -10)
  pfUI.gui.bar.title:SetFontObject(GameFontWhite)
  pfUI.gui.bar.title:SetText("ActionBar Settings")

  pfUI.gui.CreateConfig(pfUI.gui.bar, "Icon Size", pfUI_config.bars, "icon_size")
  pfUI.gui.CreateConfig(pfUI.gui.bar, "Border", pfUI_config.bars, "border")

  -- Panel settings
  pfUI.gui.panel = CreateFrame("Frame", nil, pfUI.gui)
  pfUI.gui.panel:SetWidth(400)
  pfUI.gui.panel:SetHeight(320)

  pfUI.gui.panel:SetBackdrop(pfUI.backdrop)
  pfUI.gui.panel:SetBackdropColor(0,0,0,.50);
  pfUI.gui.panel:SetPoint("RIGHT",0,0)

  pfUI.gui.panel.switch = CreateFrame("Button", nil, pfUI.gui)
  pfUI.gui.panel.switch:ClearAllPoints()
  pfUI.gui.panel.switch:SetWidth(80)
  pfUI.gui.panel.switch:SetHeight(20)
  pfUI.gui.panel.switch:SetPoint("TOPLEFT", 0, -60)
  pfUI.gui.panel.switch:SetBackdrop(pfUI.backdrop)
  pfUI.gui.panel.switch.text = pfUI.gui.panel.switch:CreateFontString("Status", "LOW", "GameFontNormal")
  pfUI.gui.panel.switch.text:SetFont("Interface\\AddOns\\pfUI\\fonts\\arial.ttf", 9, "OUTLINE")
  pfUI.gui.panel.switch.text:ClearAllPoints()
  pfUI.gui.panel.switch.text:SetAllPoints(pfUI.gui.panel.switch)
  pfUI.gui.panel.switch.text:SetPoint("CENTER", 0, 0)
  pfUI.gui.panel.switch.text:SetFontObject(GameFontWhite)
  pfUI.gui.panel.switch.text:SetText("Panels")
  pfUI.gui.panel.switch:SetScript("OnClick", function()
      pfUI.gui.SwitchTab(pfUI.gui.panel)
    end)

  pfUI.gui.panel.title = pfUI.gui.panel:CreateFontString("Status", "LOW", "GameFontNormal")
  pfUI.gui.panel.title:SetFont("Interface\\AddOns\\pfUI\\fonts\\arial.ttf", 12, "OUTLINE")
  pfUI.gui.panel.title:SetPoint("TOP", 0, -10)
  pfUI.gui.panel.title:SetFontObject(GameFontWhite)
  pfUI.gui.panel.title:SetText("Panel Settings")

  pfUI.gui.CreateConfig(pfUI.gui.panel, "Left Panel: Left", pfUI_config.panel.left, "left")
  pfUI.gui.CreateConfig(pfUI.gui.panel, "Left Panel: Center", pfUI_config.panel.left, "center")
  pfUI.gui.CreateConfig(pfUI.gui.panel, "Left Panel: Right", pfUI_config.panel.left, "right")

  pfUI.gui.CreateConfig(pfUI.gui.panel, "Right Panel: Left", pfUI_config.panel.right, "left")
  pfUI.gui.CreateConfig(pfUI.gui.panel, "Right Panel: Center", pfUI_config.panel.right, "center")
  pfUI.gui.CreateConfig(pfUI.gui.panel, "Right Panel: Right", pfUI_config.panel.right, "right")

  pfUI.gui.CreateConfig(pfUI.gui.panel, "Other Panel: Minimap", pfUI_config.panel.other, "minimap")


  -- Tooltip settings
  pfUI.gui.tooltip = CreateFrame("Frame", nil, pfUI.gui)
  pfUI.gui.tooltip:SetWidth(400)
  pfUI.gui.tooltip:SetHeight(320)

  pfUI.gui.tooltip:SetBackdrop(pfUI.backdrop)
  pfUI.gui.tooltip:SetBackdropColor(0,0,0,.50);
  pfUI.gui.tooltip:SetPoint("RIGHT",0,0)

  pfUI.gui.tooltip.switch = CreateFrame("Button", nil, pfUI.gui)
  pfUI.gui.tooltip.switch:ClearAllPoints()
  pfUI.gui.tooltip.switch:SetWidth(80)
  pfUI.gui.tooltip.switch:SetHeight(20)
  pfUI.gui.tooltip.switch:SetPoint("TOPLEFT", 0, -80)
  pfUI.gui.tooltip.switch:SetBackdrop(pfUI.backdrop)
  pfUI.gui.tooltip.switch.text = pfUI.gui.tooltip.switch:CreateFontString("Status", "LOW", "GameFontNormal")
  pfUI.gui.tooltip.switch.text:SetFont("Interface\\AddOns\\pfUI\\fonts\\arial.ttf", 9, "OUTLINE")
  pfUI.gui.tooltip.switch.text:ClearAllPoints()
  pfUI.gui.tooltip.switch.text:SetAllPoints(pfUI.gui.tooltip.switch)
  pfUI.gui.tooltip.switch.text:SetPoint("CENTER", 0, 0)
  pfUI.gui.tooltip.switch.text:SetFontObject(GameFontWhite)
  pfUI.gui.tooltip.switch.text:SetText("Tooltips")
  pfUI.gui.tooltip.switch:SetScript("OnClick", function()
      pfUI.gui.SwitchTab(pfUI.gui.tooltip)
    end)

  pfUI.gui.tooltip.title = pfUI.gui.tooltip:CreateFontString("Status", "LOW", "GameFontNormal")
  pfUI.gui.tooltip.title:SetFont("Interface\\AddOns\\pfUI\\fonts\\arial.ttf", 12, "OUTLINE")
  pfUI.gui.tooltip.title:SetPoint("TOP", 0, -10)
  pfUI.gui.tooltip.title:SetFontObject(GameFontWhite)
  pfUI.gui.tooltip.title:SetText("Tooltip Settings")

  pfUI.gui.CreateConfig(pfUI.gui.tooltip, "Tooltip Position:", pfUI_config.tooltip, "position")


  -- Unlock Frames
  pfUI.gui.unlockFrames = CreateFrame("Button", nil, pfUI.gui)
  pfUI.gui.unlockFrames:ClearAllPoints()
  pfUI.gui.unlockFrames:SetWidth(80)
  pfUI.gui.unlockFrames:SetHeight(20)
  pfUI.gui.unlockFrames:SetPoint("BOTTOMLEFT", 0, 20)
  pfUI.gui.unlockFrames:SetBackdrop(pfUI.backdrop)
  pfUI.gui.unlockFrames.text = pfUI.gui.unlockFrames:CreateFontString("Status", "LOW", "GameFontNormal")
  pfUI.gui.unlockFrames.text:SetFont("Interface\\AddOns\\pfUI\\fonts\\arial.ttf", 9, "OUTLINE")
  pfUI.gui.unlockFrames.text:ClearAllPoints()
  pfUI.gui.unlockFrames.text:SetAllPoints(pfUI.gui.unlockFrames)
  pfUI.gui.unlockFrames.text:SetPoint("CENTER", 0, 0)
  pfUI.gui.unlockFrames.text:SetFontObject(GameFontWhite)
  pfUI.gui.unlockFrames.text:SetText("Unlock Frames")
  pfUI.gui.unlockFrames:SetScript("OnClick", function()
      pfUI.gui.UnlockFrames()
    end)

  -- Hide GUI
  pfUI.gui.hideGUI = CreateFrame("Button", nil, pfUI.gui)
  pfUI.gui.hideGUI:ClearAllPoints()
  pfUI.gui.hideGUI:SetWidth(80)
  pfUI.gui.hideGUI:SetHeight(20)
  pfUI.gui.hideGUI:SetPoint("BOTTOMLEFT", 0, 0)
  pfUI.gui.hideGUI:SetBackdrop(pfUI.backdrop)
  pfUI.gui.hideGUI.text = pfUI.gui.hideGUI:CreateFontString("Status", "LOW", "GameFontNormal")
  pfUI.gui.hideGUI.text:SetFont("Interface\\AddOns\\pfUI\\fonts\\arial.ttf", 9, "OUTLINE")
  pfUI.gui.hideGUI.text:ClearAllPoints()
  pfUI.gui.hideGUI.text:SetAllPoints(pfUI.gui.hideGUI)
  pfUI.gui.hideGUI.text:SetPoint("CENTER", 0, 0)
  pfUI.gui.hideGUI.text:SetFontObject(GameFontWhite)
  pfUI.gui.hideGUI.text:SetText("Close")
  pfUI.gui.hideGUI:SetScript("OnClick", function()
    pfUI.gui:Hide()
  end)

  -- Switch to default View: global
  pfUI.gui.SwitchTab(pfUI.gui.global)
end)
