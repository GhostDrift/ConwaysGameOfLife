local gfx = playdate.graphics
local snd = playdate.sound
class('Note').extends()
function Note:init(attack,decay,sustain,release,pitch,length,vol,wave)
    self.synth = snd.synth.new(wave)
    self.synth:setADSR(attack,decay,sustain,release)
    self.pitch = pitch
    self.length = length
    self.vol = vol
end

