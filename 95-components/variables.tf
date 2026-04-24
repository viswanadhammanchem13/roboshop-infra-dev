variable "component" {
    default = {
        catalogue = {
            rule_priority = 20
        }
        user = {
            rule_priority = 30
        }
        cart = {
            rule_priority = 40
        }
        shipping = {
            rule_priority = 50
        }
        payment = {
            rule_priority = 60
        }
        frontend = {
            rule_priority = 10
        }
    } 
}