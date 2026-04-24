module "component" {
    for_each = var.component
    source = "../../terraform-aws-roboshop"

    component = each.key
    rule_priority = each.value.rule_priority
}