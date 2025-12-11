package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestBasicInstance(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: "../../examples/single-instance",
		Vars: map[string]interface{}{
			"environment": "test",
			"project":     "terratest",
		},
	}

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	instanceID := terraform.Output(t, terraformOptions, "instance_id")
	assert.NotEmpty(t, instanceID)
}

func TestASG(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: "../../examples/asg",
		Vars: map[string]interface{}{
			"environment": "test",
			"project":     "terratest",
		},
	}

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	asgName := terraform.Output(t, terraformOptions, "asg_name")
	assert.NotEmpty(t, asgName)
}
