module "component" {
    for_each = var.component
    source = "git::https://github.com/viswanadhammanchem13/terraform-aws-roboshop.git?ref=main"

    component = each.key
    rule_priority = each.value.rule_priority
}