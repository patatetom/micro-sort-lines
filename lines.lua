if GetOption("sort") == nil then
    AddOption("sort", true)
end

MakeCommand("sort", "lines.sort", 0)

function sort(reverse)
    local view = CurView()
    local cursor = view.Cursor
    if cursor:HasSelection() then
        start, stop = cursor.CurSelection[1], cursor.CurSelection[2]
        if (start.X + stop.X) ~= 0 then
            messenger:Error('wrong selection: must be whole lines with EOL')
            return
        end
        if reverse and reverse ~= "-r" then
            messenger:Error('usage: sort [-r]')
        end
        selection = cursor:GetSelection()
        lines = {}
        for line in selection:gmatch("([^\n]+)\n?") do
            table.insert(lines, line)
        end
        if reverse then
            table.sort(lines, function(a,b) return a>b end)
        else
            table.sort(lines)
        end        
        selection = table.concat(lines, "\n").."\n"
        view.Buf:Replace(Loc(0, start.Y), Loc(0, stop.Y), selection)
    end
end
