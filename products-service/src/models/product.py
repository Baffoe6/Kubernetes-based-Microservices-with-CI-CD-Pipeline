from marshmallow import Schema, fields, validate

class ProductSchema(Schema):
    name = fields.Str(required=True, validate=validate.Length(min=1, max=100))
    description = fields.Str(validate=validate.Length(max=500))
    price = fields.Float(required=True, validate=validate.Range(min=0))
    category = fields.Str(required=True, validate=validate.Length(min=1, max=50))
    stock = fields.Int(validate=validate.Range(min=0))
