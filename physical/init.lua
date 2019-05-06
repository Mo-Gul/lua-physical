--[[
Copyright (c) 2019 Thomas Jenni (tjenni@me.com)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]--

local current_folder = (...):gsub('%.init$', '')

-- Source: http://kiki.to/blog/2014/04/12/rule-5-beware-of-multiple-files/

local Dimension = require(current_folder .. '.dimension')
local Unit = require(current_folder .. '.unit')
local Quantity = require(current_folder .. '.quantity')
local Number = require(current_folder .. '.number')

require(current_folder .. '.definition')

local Data = require(current_folder .. '.data')

local m = {
	Dimension = Dimension,
	Unit = Unit,
	Number = Number,
	Quantity = Quantity,
	Data = Data
}

return m