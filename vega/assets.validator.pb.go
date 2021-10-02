// Code generated by protoc-gen-gogo. DO NOT EDIT.
// source: vega/assets.proto

package vega

import (
	fmt "fmt"
	math "math"

	proto "github.com/golang/protobuf/proto"
	github_com_mwitkow_go_proto_validators "github.com/mwitkow/go-proto-validators"
)

// Reference imports to suppress errors if they are not otherwise used.
var _ = proto.Marshal
var _ = fmt.Errorf
var _ = math.Inf

func (this *Asset) Validate() error {
	if this.Details != nil {
		if err := github_com_mwitkow_go_proto_validators.CallValidatorIfExists(this.Details); err != nil {
			return github_com_mwitkow_go_proto_validators.FieldError("Details", err)
		}
	}
	return nil
}
func (this *AssetDetails) Validate() error {
	if oneOfNester, ok := this.GetSource().(*AssetDetails_BuiltinAsset); ok {
		if oneOfNester.BuiltinAsset != nil {
			if err := github_com_mwitkow_go_proto_validators.CallValidatorIfExists(oneOfNester.BuiltinAsset); err != nil {
				return github_com_mwitkow_go_proto_validators.FieldError("BuiltinAsset", err)
			}
		}
	}
	if oneOfNester, ok := this.GetSource().(*AssetDetails_Erc20); ok {
		if oneOfNester.Erc20 != nil {
			if err := github_com_mwitkow_go_proto_validators.CallValidatorIfExists(oneOfNester.Erc20); err != nil {
				return github_com_mwitkow_go_proto_validators.FieldError("Erc20", err)
			}
		}
	}
	return nil
}
func (this *BuiltinAsset) Validate() error {
	return nil
}
func (this *ERC20) Validate() error {
	return nil
}
