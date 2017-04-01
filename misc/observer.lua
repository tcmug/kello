

module = {}

local observer = {}

function observer:subscribe(subject)
    table.insert(subject.observers, self)
    table.insert(self.subjects, subject)
end

function observer:unsubscribe(subject)
    table.remove(subject.observers, self)
    table.remove(self.subjects, subject)
end

function module:create()
    self.subjects = {}
end

return module


