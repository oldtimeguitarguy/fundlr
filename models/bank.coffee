mongoose = require 'mongoose'

# Import base schema
BankSchema = require './_schema'

# Set fields
BankSchema.add
  name: String

# INSTANTIATE AND EXPORT ---------------
module.exports = mongoose.model 'Bank', BankSchema